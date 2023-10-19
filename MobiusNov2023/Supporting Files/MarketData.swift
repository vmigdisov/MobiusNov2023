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
    let price: Int
    
    static let sampleData = {
        var data = [MarketData]()
        Asset.portfolio.forEach { asset in
            let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
            var lastPrice = 0
            for days in 0...30 {
                let date = Calendar.current.date(byAdding: .day, value: days, to: startDate)!
                let change = Int.random(in: -3...3)
                let currentPrice = lastPrice + change
                data.append(
                    MarketData(asset: asset.name, date: date, price: currentPrice)
                )
                lastPrice = currentPrice
            }
        }
        return data
    }()
    
    var avg: Int {
        let quotes = MarketData.sampleData.filter({ $0.asset == asset })
        return quotes.reduce(0) { prev, data in data.price + prev } / quotes.count
    }
}
