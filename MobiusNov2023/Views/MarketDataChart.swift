//
//  MarketDataChart.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 02.08.2023.
//

import SwiftUI

struct MarketDataChart: View {
    @ObservedObject var motionDetector = MotionDetector.shared
    
    var body: some View {
        
        Text("")
        //Image(systemName: .lockImage)
    }
}

struct MarketDataChart_Previews: PreviewProvider {
    static var previews: some View {
        MarketDataChart()
    }
}
