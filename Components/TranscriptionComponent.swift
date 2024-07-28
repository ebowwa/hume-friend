//
//  TranscriptionComponent.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/19/24.
//
import SwiftUI

struct TranscriptionComponent: View {
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Transcribing...")
                            .font(.subheadline)
                            .foregroundColor(Color("mutedForeground"))
                        
                        Spacer()
                        
                        Text("1:23")
                            .font(.subheadline)
                            .foregroundColor(Color("mutedForeground"))
                    }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("muted"))
                        .frame(height: 96)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color("primary"), Color("secondary")]), startPoint: .leading, endPoint: .trailing))
                                .opacity(0.5)
                                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: UUID())
                        )
                    
                    Text("The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.")
                        .font(.body)
                        .lineSpacing(5)
                }
                .padding()
                .background(Color("card"))
                .cornerRadius(16)
                .shadow(radius: 4)
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

struct TranscriptionComponent_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptionComponent()
            .previewLayout(.sizeThatFits)
            .background(Color("background"))
    }
}
