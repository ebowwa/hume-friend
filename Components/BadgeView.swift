//
//  BadgeView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct BadgeView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
    }
}
