//
//  SplashConnecting.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/16/24.
//
import SwiftUI

struct TitleView: View {
    var body: some View {
        Text("Connecting with Your Furry Friend")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(Color(hex: "#ffffff"))
    }
}

struct ScanningStateView: View {
    var body: some View {
        Text("Hey, Pet Parents! Give us one sec while we connect")
            .font(.title2)
            .foregroundColor(Color(hex: "#ffffff"))
    }
}

struct ConnectingTextView: View {
    var body: some View {
        Text("Connecting with your pets 😊")
            .font(.footnote)
            .foregroundColor(Color(hex: "#ffffff"))
    }
}

struct ConnectedStateView: View {
    var body: some View {
        Text("Device found! Proceeding...")
            .font(.title2)
            .foregroundColor(Color(hex: "#ffffff"))
    }
}
