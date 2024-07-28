//
//  DeviceContentContainerView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import SwiftUI

struct DeviceContentContainerView: View {
    var body: some View {
        VStack(spacing: 16) {
            DeviceTextContainerView()
            ConnectButtonView()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}
