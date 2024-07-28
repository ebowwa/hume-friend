//
//  LogManager.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/20/24.
//

import os
import Foundation

class LogManager {
    private let logger: Logger
    
    init() {
        logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BluetoothService")
    }
    
    func log(_ message: String, level: OSLogType = .default) {
        switch level {
        case .error:
            logger.error("\(message)")
        case .fault:
            logger.fault("\(message)")
        case .debug:
            logger.debug("\(message)")
        default:
            logger.info("\(message)")
        }
    }
}
