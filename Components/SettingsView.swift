//
//  SettingsView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
                Link("Customize", destination: URL(string: "#")!)
                    .foregroundColor(Color(hex: "#00b894"))
            }
            HStack(spacing: 16) {
                InfoBoxView(icon: "power", title: "Collar Settings", value: "Edit")
                InfoBoxView(icon: "envelope.fill", title: "Notifications", value: "Manage")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
