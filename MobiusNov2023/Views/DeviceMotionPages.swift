//
//  DeviceMotionPages.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 19.10.2023.
//

import SwiftUI

struct DeviceMotionPages: View {
    var body: some View {
        HStack(spacing: Constants.spacing) {
            NavigationLink(
                destination: MotionDataChart(dataSource: .motion)
            ) {
                MenuButtonView("Gravity Data", .cyan)
            }
            NavigationLink(
                destination: MarketDataChart()
            ) {
                MenuButtonView("Market Data", .purple)
            }
        }
        .onAppear {
            AppDelegate.orientationLock = .landscapeRight
        }
    }
    
    // MARK: - Drawing constants
    enum Constants {
        static let spacing: CGFloat = 24
    }
}

#Preview {
    DeviceMotionPages()
}
