//
//  SpinnerView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/16/24.
//
import SwiftUI

struct SpinnerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: "#ff9b9b").opacity(0.3), lineWidth: 5)
                .frame(width: 50, height: 50)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color(hex: "#ff9b9b"), lineWidth: 5)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    self.isAnimating = true
                }
        }
    }
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        SpinnerView()
    }
}
