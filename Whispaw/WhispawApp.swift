import SwiftUI
import CoreBluetooth
import AVFoundation

@main
struct HumeBLEApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isScanning = false
    @Published var isConnected = false
    @Published var isRecording = false
    @Published var deviceName: String = "Not Connected"
    @Published var batteryLevel: Int = 0
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var audioCharacteristic: CBCharacteristic?
    private var batteryCharacteristic: CBCharacteristic?
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, time in
            self?.processAudioBuffer(buffer)
        }
    }
    
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let audioFile = audioFile else { return }
        do {
            try audioFile.write(from: buffer)
        } catch {
            print("Error writing audio: \(error)")
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
            scanForDevices()
        case .poweredOff:
            print("Bluetooth is powered off")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is unsupported")
        case .unknown:
            print("Bluetooth state is unknown")
        @unknown default:
            print("Unknown Bluetooth state")
        }
    }
    
    func scanForDevices() {
        isScanning = true
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "Friend" {
            self.peripheral = peripheral
            central.stopScan()
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        deviceName = peripheral.name ?? "Unknown Device"
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: "19B10001-E8F2-537E-4F6C-D104768A1214") {
                audioCharacteristic = characteristic
            } else if characteristic.uuid == CBUUID(string: "2A19") {
                batteryCharacteristic = characteristic
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == CBUUID(string: "2A19") {
            if let value = characteristic.value {
                batteryLevel = Int(value[0])
            }
        }
    }
    
    func startRecording() {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not access documents directory")
            return
        }
        
        let audioFilename = documentsPath.appendingPathComponent("recording.wav")
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false
        ]
        
        do {
            audioFile = try AVAudioFile(forWriting: audioFilename, settings: settings)
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Could not start audio engine: \(error)")
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioFile = nil
        isRecording = false
    }
    
    func getWAVData() -> Data? {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not access documents directory")
            return nil
        }
        
        let audioFilename = documentsPath.appendingPathComponent("recording.wav")
        
        do {
            return try Data(contentsOf: audioFilename)
        } catch {
            print("Error reading audio file: \(error)")
            return nil
        }
    }
}

enum HumeAPIError: Error {
    case invalidResponse
    case serverError(String)
    case networkError(Error)
    case invalidData
}

class HumeAPIManager {
    static func startInferenceJobFromData(apiKey: String, audioData: Data, completion: @escaping (Result<String, HumeAPIError>) -> Void) {
        let url = URL(string: "https://api.hume.ai/v0/batch/jobs")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "X-Hume-Api-Key")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audioFile.wav\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown server error"
                completion(.failure(.serverError("Status code: \(httpResponse.statusCode), Error: \(errorMessage)")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let jobId = json["job_id"] as? String {
                    completion(.success(jobId))
                } else {
                    completion(.failure(.invalidData))
                }
            } catch {
                completion(.failure(.networkError(error)))
            }
        }
        
        task.resume()
    }
}

struct ContentView: View {
    @StateObject private var bleManager = BLEManager()
    @State private var apiKey = ""
    @State private var jobId: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Device Information")) {
                    Text("Status: \(bleManager.isConnected ? "Connected" : "Disconnected")")
                    Text("Device: \(bleManager.deviceName)")
                    Text("Battery: \(bleManager.batteryLevel)%")
                }
                
                Section(header: Text("API Configuration")) {
                    SecureField("Hume.ai API Key", text: $apiKey)
                }
                
                Section {
                    Button(action: {
                        if bleManager.isConnected {
                            if bleManager.isRecording {
                                bleManager.stopRecording()
                                sendAudioToHume()
                            } else {
                                bleManager.startRecording()
                            }
                        } else {
                            bleManager.scanForDevices()
                        }
                    }) {
                        Text(buttonText)
                    }
                }
                
                if let jobId = jobId {
                    Section(header: Text("Job Information")) {
                        Text("Job ID: \(jobId)")
                    }
                }
            }
            .navigationTitle("Emotional Analyzer")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    var buttonText: String {
        if !bleManager.isConnected {
            return "Scan for Devices"
        } else if bleManager.isRecording {
            return "Stop Recording"
        } else {
            return "Start Recording"
        }
    }
    
    func sendAudioToHume() {
        guard !apiKey.isEmpty else {
            showAlert(message: "Please enter your Hume.ai API key")
            return
        }
        
        guard let audioData = bleManager.getWAVData() else {
            showAlert(message: "Failed to get audio data")
            return
        }
        
        HumeAPIManager.startInferenceJobFromData(apiKey: apiKey, audioData: audioData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let jobId):
                    self.jobId = jobId
                    showAlert(message: "Job started successfully")
                case .failure(let error):
                    switch error {
                    case .serverError(let message):
                        showAlert(message: "Server Error: \(message)")
                    case .networkError(let error):
                        showAlert(message: "Network Error: \(error.localizedDescription)")
                    case .invalidResponse:
                        showAlert(message: "Invalid response from server")
                    case .invalidData:
                        showAlert(message: "Invalid data received from server")
                    }
                }
            }
        }
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
