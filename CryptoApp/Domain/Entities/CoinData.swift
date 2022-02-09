//
//  CoinData.swift
//  CryptoApp
//
//  Created by aleksandre on 09.02.22.
//


import Foundation

typealias CoinDataDTOResponse = CoinDataDTO


struct CoinDataDTO: Codable {
    
    let id: String
    let symbol: String
    let name: String
    let description: Description
    let image: Image
    let marketData: MarketData
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case description
        case image
        case marketData = "market_data"
    }
}


struct Description: Codable {
    
    let en: String
}

struct Image: Codable {
    let thumb, small, large: String
}

struct MarketData: Codable {
    
    let currentPrice: [String: Double]
    let marketCap: [String: Double]
    let marketCapRank: Int
    let sparkline7D: Sparkline7D
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case sparkline7D = "sparkline_7d"
    }
}

struct Sparkline7D: Codable {
    
    let price: [Double]
}


struct CoinData {
    
    let currentPrice: String
    let marketCap: String
    let sparkLine7D: [Double]
    
    init(_ coinData: CoinDataDTO) {
        
        // Obtain only usd value
        if let priceInUSD = coinData.marketData.currentPrice.first(where: { $0.key == "usd" }) {
            self.currentPrice = "$" +  priceInUSD.value.formattedWithAbbreviations()
        } else {
            self.currentPrice = ""
        }
        if let marketCapInUSD = coinData.marketData.marketCap.first(where: { $0.key == "usd" }) {
            self.marketCap = marketCapInUSD.value.formattedWithAbbreviations()
        } else {
            self.marketCap = ""
        }
        
        self.sparkLine7D = coinData.marketData.sparkline7D.price
        
    }
}
