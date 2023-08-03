//
//  MotionDataChart.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 01.08.2023.
//

import SwiftUI
import Charts

struct MotionDataChart: View {
    
    enum DataSource {
        case accelerometer, gyroscope, motion
    }
    
    let dataSource: DataSource
    @ObservedObject private var motionDetector = MotionDetector.shared
    @ObservedObject private var chartAxisSwitcherViewModel = ChartAxisSwitcherViewModel()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Chart(motionDetector.data.filter { model in
                model.axis == .x && chartAxisSwitcherViewModel.showX ||
                model.axis == .y && chartAxisSwitcherViewModel.showY ||
                model.axis == .z && chartAxisSwitcherViewModel.showZ
            }) {
                LineMark(
                    x: .value("TimeStamp", $0.date),
                    y: .value("Value", $0.value)
                )
                .foregroundStyle(by: .value("Axis", $0.axis.rawValue))
            }
            ChartAxisSwitcher(viewModel: chartAxisSwitcherViewModel)
        }
        .onAppear {
            switch dataSource {
            case .accelerometer:
                MotionDetector.shared.startAccelerometerDetector()
            case .gyroscope:
                MotionDetector.shared.startGyroscopeDetector()
            case .motion:
                MotionDetector.shared.startMotionDetector()
            }
            AppDelegate.orientationLock = .landscapeRight
        }
        .onDisappear {
            MotionDetector.shared.stopDetector()
        }
    }
}

struct RotationDetectorChart_Previews: PreviewProvider {
    static var previews: some View {
        MotionDataChart(dataSource: .motion)
    }
}
