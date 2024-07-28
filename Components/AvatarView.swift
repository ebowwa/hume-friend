//
//  AvatarView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/18/24.
//

import SwiftUI

struct AvatarView: View {
    var body: some View {
        Image("pug-silhouette") // https://drive.google.com/drive/folders/1n1_HINIvDE4uBtDCcQSOR6mz2_ai-R36?usp=share_link see the collection
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}
