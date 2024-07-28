//
//  PetInfoView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct PetInfoView: View {
    @ObservedObject var deviceModel: DeviceModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Buddy")
                        .font(.headline)
                    Text("Mood: Happy")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                BadgeView(text: "No Alerts")
            }
            HStack(spacing: 16) {
                InfoBoxView(icon: "mic.fill", title: "Voice Battery", value: "\(deviceModel.batteryLevel)%")
                InfoBoxView(icon: "moon.fill", title: "Mood", value: "Excited")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
