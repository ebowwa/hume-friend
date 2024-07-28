//
//  ConnectButtonView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import SwiftUI

struct ConnectButtonView: View {
    var body: some View {
        Button(action: {
            // Action to perform when the button is tapped
        }) {
            Text("Connect")
                .font(.system(size: 16, weight: .medium))
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
