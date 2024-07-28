//
//  DeviceModelDelegate.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import Foundation

protocol DeviceModelDelegate: AnyObject {
    func didReceiveAudioData(_ data: Data)
}
