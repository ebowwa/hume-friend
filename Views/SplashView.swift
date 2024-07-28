//
//  SplashView.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/16/24.
//
import SwiftUI

struct SplashView: View {
    @StateObject private var bluetoothService = BluetoothService()

    var body: some View {
        ZStack {
            BackgroundGradientView()
            
            VStack(spacing: 20) {
                TitleView() 
                if bluetoothService.isScanning {
                    ScanningStateView()
                    SpinnerView()
                    ConnectingTextView()
                } else {
                    ConnectedStateView()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
        }
        .onAppear {
            bluetoothService.startScanning()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
