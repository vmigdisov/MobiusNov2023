//
//  ContentView.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 01.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: Constants.spacing) {
                NavigationLink(
                    destination: NotificationCenterView()
                ) {
                    MenuButtonView("Notification Center", .mint)
                }
                NavigationLink(
                    destination: MotionDataChart(dataSource: .accelerometer)
                ) {
                    MenuButtonView("Accelerometer", .blue)
                }
                NavigationLink(
                    destination: MotionDataChart(dataSource: .gyroscope)
                ) {
                    MenuButtonView("Gyroscope", .green)
                }
                NavigationLink(
                    destination: DeviceMotionPages()
                ) {
                    MenuButtonView("Device Motion", .cyan)
                }
            }
            .onAppear {
                AppDelegate.orientationLock = .portrait
            }
        }
    }
    
    // MARK: - Drawing constants
    enum Constants {
        static let spacing: CGFloat = 24
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
