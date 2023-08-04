//
//  MarketData.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 04.08.2023.
//

import Foundation

struct Asset {
    let name: String
    
    static let portfolio = [
        Asset(name: "Акция"),
        Asset(name: "Облигация"),
        Asset(name: "АДР"),
        Asset(name: "Фьючерс"),
        Asset(name: "Опцион")
    ]
}

struct MarketData: Identifiable {
    let id = UUID()
    let asset: String
    let date: Date
    let price: Double
    
    static let sampleData = {
        var data = [MarketData]()
        Asset.portfolio.forEach { asset in
            let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
            for days in 0...100 {
                let date = Calendar.current.date(byAdding: .day, value: days, to: startDate)
                data.append(
                    MarketData(asset: asset.name, date: Date(), price: Double.random(in: 5.0 ..< 30.0))
                )
            }
        }
        return data
    }()
}
