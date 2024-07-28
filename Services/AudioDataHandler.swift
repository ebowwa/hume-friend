//
//  AudioDataHandler.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

// AudioDataHandler.swift
import Foundation
import CoreBluetooth

class AudioDataHandler: NSObject, CBPeripheralDelegate {
    private var peripheral: CBPeripheral?
    private var characteristics: [CBUUID: CBCharacteristic] = [:]
    weak var delegate: DeviceModelDelegate?

    init(peripheral: CBPeripheral?) {
        self.peripheral = peripheral
        super.init()
        self.peripheral?.delegate = self
    }

    // MARK: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            self.characteristics[characteristic.uuid] = characteristic
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            if characteristic.uuid == CBUUID(string: "19B10001-E8F2-537E-4F6C-D104768A1214") {
                delegate?.didReceiveAudioData(value)
            }
        }
    }
}
