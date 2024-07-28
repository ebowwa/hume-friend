//
//  DeviceModel.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/16/24.
//

import Foundation
import CoreBluetooth

class DeviceModel: NSObject, ObservableObject, CBPeripheralDelegate {
    static let shared = DeviceModel()

    @Published var name: String?
    @Published var uuid: UUID?
    @Published var isConnected: Bool = false
    @Published public var batteryLevel: Int = 0 {
        didSet {
            print("Battery level: \(batteryLevel)%")
        }
    }
    
    private var peripheral: CBPeripheral?
    private var services: [CBService] = []
    private var characteristics: [CBUUID: CBCharacteristic] = [:]
    private var serviceUUIDs: [CBUUID]?

    private override init() {
        super.init()
    }

    func configure(name: String? = nil, uuid: UUID? = nil, peripheral: CBPeripheral? = nil, serviceUUIDs: [CBUUID]? = nil) {
        self.name = name
        self.uuid = uuid
        self.peripheral = peripheral
        self.serviceUUIDs = serviceUUIDs
        self.peripheral?.delegate = self
    }

    func connect() {
        isConnected = true
        discoverServices()
        print("Connecting to the device and discovering services")
    }

    func disconnect() {
        isConnected = false
        print("Disconnecting from the device")
    }

    private func discoverServices() {
        if let serviceUUIDs = serviceUUIDs {
            peripheral?.discoverServices(serviceUUIDs)
        } else {
            peripheral?.discoverServices(nil)
        }
    }

    // MARK: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        self.services = services
        print("Discovered services:")
        for service in services {
            print("Service UUID: \(service.uuid)")
            discoverCharacteristics(for: service)
        }
    }

    private func discoverCharacteristics(for service: CBService) {
        peripheral?.discoverCharacteristics(nil, for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        print("Discovered characteristics for service \(service.uuid):")
        for characteristic in characteristics {
            self.characteristics[characteristic.uuid] = characteristic
            print("Characteristic UUID: \(characteristic.uuid)")
            handleCharacteristic(characteristic)
        }
    }

    private func handleCharacteristic(_ characteristic: CBCharacteristic) {
        if characteristic.properties.contains(.read) {
            peripheral?.readValue(for: characteristic)
        }
        if characteristic.properties.contains(.notify) {
            peripheral?.setNotifyValue(true, for: characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            print("Updated value for \(characteristic.uuid): \(value)")
            handleValueUpdate(for: characteristic, value: value)
        }
    }

    private func handleValueUpdate(for characteristic: CBCharacteristic, value: Data) {
        if characteristic.uuid == CBUUID(string: "19B10002-E8F2-537E-4F6C-D104768A1214") {
            handleCodecTypeUpdate(value)
        } else if characteristic.uuid == CBUUID(string: "2A19") {
            handleBatteryLevelUpdate(value)
        }
    }

    private func handleCodecTypeUpdate(_ value: Data) {
        if let codecType = value.first {
            switch codecType {
            case 0:
                print("Codec type: PCM 16-bit, 16kHz, mono")
            case 1:
                print("Codec type: PCM 8-bit, 16kHz, mono")
            case 10:
                print("Codec type: Mu-law 16-bit, 16kHz, mono")
            case 11:
                print("Codec type: Mu-law 8-bit, 16kHz, mono")
            case 20:
                print("Codec type: Opus 16-bit, 16kHz, mono")
            default:
                print("Unknown codec type")
            }
        }
    }

    private func handleBatteryLevelUpdate(_ value: Data) {
        if let batteryLevel = value.first {
            print("Battery Level: \(batteryLevel)%")
            self.batteryLevel = Int(batteryLevel)
        }
    }

    func writeValue(data: Data, to characteristic: CBCharacteristic) {
        peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
            return
        }
        print("Successfully wrote value for characteristic \(characteristic.uuid)")
    }
}
