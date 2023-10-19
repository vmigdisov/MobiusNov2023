//
//  MarketDataChart.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 02.08.2023.
//

import SwiftUI
import Charts

struct MarketDataChart: View {
    @ObservedObject var motionDetector = MotionDetector.shared
    
    var body: some View {
        ZStack {
            if motionDetector.lock {
                Image(systemName: .lockImage)
                    .resizable()
                    .frame(
                        width: Constants.lockSize,
                        height: Constants.lockSize
                    )
            } else {
                VStack {
                    Text(Asset.portfolio[motionDetector.assetIndex].name)
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                        .padding(.top)
                    Chart(MarketData.sampleData.filter {
                        $0.asset == Asset.portfolio[motionDetector.assetIndex].name
                    }) {
                        LineMark(
                            x: .value("TimeStamp", $0.date),
                            y: .value("Value", $0.price),
                            series: .value("price", "A")
                        ).foregroundStyle(.red)
                        if motionDetector.showIndicators {
                            LineMark(
                                x: .value("TimeStamp", $0.date),
                                y: .value("Value", $0.avg),
                                series: .value("mid", "B")
                            ).foregroundStyle(.green)                            
                        }
                    }
                }
            }
        }
        .onAppear {
            AppDelegate.orientationLock = .landscapeRight
            MotionDetector.shared.startMotionDetector()
        }
        .onDisappear {
            MotionDetector.shared.stopDetector()
        }
    }
    
    // MARK: - Drwaing constants
    
    private enum Constants {
        static let lockSize: CGFloat = 200
    }
}

struct MarketDataChart_Previews: PreviewProvider {
    static var previews: some View {
        MarketDataChart()
    }
}
