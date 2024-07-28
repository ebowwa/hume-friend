//
//  DeviceTextContainerView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import SwiftUI

struct DeviceTextContainerView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Connect Your Pet Collar")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color(UIColor.label))
            
            Text("Pair your device to start tracking your pet's activity.")
                .font(.subheadline)
                .foregroundColor(Color(UIColor.secondaryLabel))
        }
        .multilineTextAlignment(.center)
    }
}
