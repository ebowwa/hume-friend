//
//  BackgroundGradientView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//
import SwiftUI

struct BackgroundGradientView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#f5f5f5"), Color(hex: "#e0e0e0")]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.light)
        
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#1e1e1e"), Color(hex: "#121212")]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}
