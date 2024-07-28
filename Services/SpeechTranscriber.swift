//
//  SpeechTranscriber.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import Foundation
import Speech
import AVFoundation

class SpeechTranscriber: NSObject, DeviceModelDelegate {
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioDataHandler: AudioDataHandler?

    override init() {
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
        super.init()
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Authorized")
            case .denied:
                print("User denied access to speech recognition")
            case .restricted:
                print("Speech recognition restricted on this device")
            case .notDetermined:
                print("Speech recognition not yet authorized")
            @unknown default:
                fatalError()
            }
        }
    }

    func setupAudioDataHandler(_ audioDataHandler: AudioDataHandler) {
        self.audioDataHandler = audioDataHandler
        self.audioDataHandler?.delegate = self
    }

    func startTranscription() {
        configureAudioSession()
        startAudioEngine()
        startRecognitionTask()
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func startAudioEngine() {
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }

    private func startRecognitionTask() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let transcribedText = result.bestTranscription.formattedString
                print("Transcribed Text: \(transcribedText)")
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }

    func stopTranscription() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
    }

    // MARK: - DeviceModelDelegate

    func didReceiveAudioData(_ data: Data) {
        guard let recognitionRequest = recognitionRequest else { return }
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: true)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: UInt32(data.count) / audioFormat!.streamDescription.pointee.mBytesPerFrame) else { return }
        buffer.frameLength = buffer.frameCapacity
        let audioBuffer = buffer.int16ChannelData!.pointee
        data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            guard let baseAddress = pointer.baseAddress else { return }
            audioBuffer.update(from: baseAddress.assumingMemoryBound(to: Int16.self), count: data.count / 2)
        }
        recognitionRequest.append(buffer)
    }
}
