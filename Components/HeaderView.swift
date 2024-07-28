//
//  HeaderView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            BackgroundGradientView()
                .frame(height: 60) // Adjust the height to match the original header size
            
            HStack {
                HStack {
                    Text("Whispaw")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Spacer()
                AvatarView()
            }
            .padding()
        }
    }
}
