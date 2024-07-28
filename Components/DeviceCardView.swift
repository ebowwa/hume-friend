//
//  DeviceCardView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct DeviceCardView: View {
    var batteryLevel: Int?

    var body: some View {
        VStack(spacing: 20) {
            // Pet Collar Image
            Image("pug-silhouette")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(hex: "#f5f5f5"), lineWidth: 4))
                .shadow(radius: 10)
            
            // Title
            Text("Paw Protector")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Subtitle
            Text("Bluetooth-Connected Pet Collar")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Buttons
            HStack(spacing: 16) {
                Button(action: {
                    // Connect action
                }) {
                    Text("Disconnect")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Manage action
                }) {
                    Text("Settings")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
            
            // Battery Level
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Battery Level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    if let batteryLevel = batteryLevel {
                        Text("\(batteryLevel)%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    } else {
                        Text("Battery level not available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 8)
                        .foregroundColor(Color(hex: "#f5f5f5"))
                        .cornerRadius(4)
                    
                    if let batteryLevel = batteryLevel {
                        Rectangle()
                            .frame(width: CGFloat(batteryLevel) * 2, height: 8)
                            .foregroundColor(Color(hex: "#4CAF50"))
                            .cornerRadius(4)
                    }
                }
            }
            
            // Connection Status
            HStack {
                Text("Connection Status")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Connected")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(hex: "#ffffff"))
        .cornerRadius(30)
        .shadow(radius: 10)
        .padding()
    }
}
