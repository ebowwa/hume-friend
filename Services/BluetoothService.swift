//
//  BluetoothService.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/16/24.
//
import Foundation
import CoreBluetooth
import os

class BluetoothService: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var isScanning = false
    @Published var connectionState: ConnectionState = .idle
    private var centralManager: CBCentralManager?
    private var targetPeripheral: CBPeripheral?
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BluetoothService")
    
    enum ConnectionState: String {
        case idle, scanning, discovering, connecting, connected, failed, disconnected
    }

    override init() {
        super.init()
        setupCentralManager()
    }

    private func setupCentralManager() {
        logger.info("Setting up Central Manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        logger.info("Attempting to start scanning. Current state: \(self.connectionState.rawValue)")
        guard let centralManager = centralManager, centralManager.state == .poweredOn else {
            logger.error("Cannot start scanning: Central manager is not powered on")
            return
        }
        
        if self.connectionState == .idle {
            self.connectionState = .scanning
            self.isScanning = true
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
            logger.info("Scanning started")
        } else {
            logger.warning("Cannot start scanning: Not in idle state")
        }
    }

    private func stopScanning() {
        logger.info("Stopping scan. Current state: \(self.connectionState.rawValue)")
        centralManager?.stopScan()
        isScanning = false
        if self.connectionState == .scanning {
            self.connectionState = .idle
        }
        logger.info("Scanning stopped")
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        logger.info("Central Manager did update state: \(central.state.rawValue)")
        switch central.state {
        case .poweredOn:
            startScanning()
        case .poweredOff:
            handleBluetoothPoweredOff()
        case .unsupported:
            logger.error("Bluetooth is not supported on this device")
        case .unauthorized:
            logger.error("Bluetooth is not authorized")
        case .resetting:
            handleBluetoothResetting()
        case .unknown:
            logger.warning("Bluetooth state is unknown")
        @unknown default:
            logger.error("An unknown Bluetooth state occurred: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        guard self.connectionState == .scanning else {
            logger.warning("Peripheral discovered but not in scanning state. Current state: \(self.connectionState.rawValue)")
            return
        }
        
        if let name = peripheral.name, name == "Friend" {
            logger.info("'Friend' device found. Attempting to connect.")
            stopScanning()
            self.connectionState = .discovering
            targetPeripheral = peripheral
            DispatchQueue.main.async {
                self.connectionState = .connecting
                self.centralManager?.connect(peripheral, options: nil)
            }
            logger.info("Connection attempt initiated for 'Friend' device")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        logger.info("Did connect to peripheral: \(peripheral.identifier.uuidString)")
        DispatchQueue.main.async {
            self.connectionState = .connected
        }
        logger.info("Connected to \(peripheral.name ?? "unknown device")")
        DeviceModel.shared.configure(name: peripheral.name, uuid: peripheral.identifier, peripheral: peripheral, serviceUUIDs: nil)
        DeviceModel.shared.connect()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        logger.error("Failed to connect to peripheral: \(peripheral.identifier.uuidString), Error: \(error?.localizedDescription ?? "unknown error")")
        DispatchQueue.main.async {
            self.connectionState = .failed
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        logger.info("Did disconnect from peripheral: \(peripheral.identifier.uuidString), Error: \(error?.localizedDescription ?? "no error")")
        DispatchQueue.main.async {
            self.connectionState = .disconnected
        }
        DeviceModel.shared.disconnect()
    }

    private func handleBluetoothPoweredOff() {
        stopScanning()
        DispatchQueue.main.async {
            self.connectionState = .idle
        }
        logger.warning("Bluetooth is powered off")
    }

    private func handleBluetoothResetting() {
        stopScanning()
        DispatchQueue.main.async {
            self.connectionState = .idle
        }
        logger.warning("Bluetooth is resetting")
    }
}
