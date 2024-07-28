//
//  HelloWave.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/19/24.
//

import SwiftUI

struct HelloWave: View {
    @State private var rotation: Double = 0

    var body: some View {
        VStack {
            Text("👋")
                .font(.system(size: 28))
                .rotationEffect(.degrees(rotation))
                .animation(
                    Animation.easeInOut(duration: 0.15)
                        .repeatCount(4, autoreverses: true),
                    value: rotation
                )
                .onAppear {
                    startAnimation()
                }
        }
    }

    private func startAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.15).repeatCount(4, autoreverses: true)) {
            self.rotation = 25
        }
    }
}

struct HelloWave_Previews: PreviewProvider {
    static var previews: some View {
        HelloWave()
    }
}
