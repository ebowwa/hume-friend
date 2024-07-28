//
//  ActivityHistoryView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct ActivityHistoryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity History")
                    .font(.headline)
                Spacer()
                Link("View All", destination: URL(string: "#")!)
                    .foregroundColor(Color(hex: "#00b894"))
            }
            HStack(spacing: 16) {
                InfoBoxView(icon: "calendar", title: "Last Walk", value: "2 hours ago")
                InfoBoxView(icon: "heart.fill", title: "Last Vet Visit", value: "3 days ago")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
