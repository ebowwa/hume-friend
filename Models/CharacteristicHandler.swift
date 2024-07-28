//
//  CharacteristicHandler.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/20/24.
//

import CoreBluetooth

class CharacteristicHandler {
    private let logManager: LogManager
    
    init(logManager: LogManager = LogManager()) {
        self.logManager = logManager
    }
    
    func handleCharacteristic(_ characteristic: CBCharacteristic, peripheral: CBPeripheral) {
        if characteristic.properties.contains(.read) {
            peripheral.readValue(for: characteristic)
        }
        if characteristic.properties.contains(.notify) {
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func handleValueUpdate(for characteristic: CBCharacteristic, value: Data) {
        switch characteristic.uuid.uuidString {
        case "19B10002-E8F2-537E-4F6C-D104768A1214":
            handleCodecTypeUpdate(value)
        case "2A19":
            handleBatteryLevelUpdate(value)
        default:
            logManager.log("Unhandled characteristic update: \(characteristic.uuid)")
        }
    }
    
    private func handleCodecTypeUpdate(_ value: Data) {
        if let codecType = value.first {
            let codecDescription = getCodecDescription(codecType)
            logManager.log("Codec type: \(codecDescription)")
        }
    }
    
    private func handleBatteryLevelUpdate(_ value: Data) {
        if let batteryLevel = value.first {
            logManager.log("Battery Level: \(batteryLevel)%")
            DeviceModel.shared.batteryLevel = Int(batteryLevel)
        }
    }
    
    private func getCodecDescription(_ codecType: UInt8) -> String {
        switch codecType {
        case 0: return "PCM 16-bit, 16kHz, mono"
        case 1: return "PCM 8-bit, 16kHz, mono"
        case 10: return "Mu-law 16-bit, 16kHz, mono"
        case 11: return "Mu-law 8-bit, 16kHz, mono"
        case 20: return "Opus 16-bit, 16kHz, mono"
        default: return "Unknown codec type"
        }
    }
}
