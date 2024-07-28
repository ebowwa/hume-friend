//
//  InfoBoxView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct InfoBoxView: View {
    var icon: String
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}
