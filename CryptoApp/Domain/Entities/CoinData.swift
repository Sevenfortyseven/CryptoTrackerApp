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
    let priceChangePercentage24H: Double
    let sparkline7D: Sparkline7D
    let marketCapChangePercentage24H: Double
    let totalVolume: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case sparkline7D = "sparkline_7d"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case totalVolume = "total_volume"
    }
}

struct Sparkline7D: Codable {
    
    let price: [Double]
}


struct CoinData {
    
    let currentPrice: String
    let coinName: String
    let marketCap: String
    let sparkLine7D: [Double]
    let imageURL: String
    let overview: String
    let priceChangePercentage24H: String
    let marketCapRank: String
    let marketCapChangePercentage24H: String
    let totalVolume: String
    
    init(_ coinData: CoinDataDTO) {
        
        // Obtain only usd value
        if let priceInUSD = coinData.marketData.currentPrice.first(where: { $0.key == "usd" }) {
            self.currentPrice = "$" + priceInUSD.value.transformToCurrencyWith6Decimals()
        } else {
            self.currentPrice = ""
        }
        if let marketCapInUSD = coinData.marketData.marketCap.first(where: { $0.key == "usd" }) {
            self.marketCap = "$" + marketCapInUSD.value.formattedWithAbbreviations()
        } else {
            self.marketCap = ""
        }
        if let totalVolumeInUSD = coinData.marketData.totalVolume.first(where: { $0.key == "usd" }) {
            self.totalVolume = "$" + totalVolumeInUSD.value.formattedWithAbbreviations()
        } else {
            self.totalVolume = ""
        }
        
        self.sparkLine7D = coinData.marketData.sparkline7D.price
        self.coinName = coinData.name
        self.imageURL = coinData.image.small

        self.overview = coinData.description.en.removeOccurances
        self.priceChangePercentage24H = coinData.marketData.priceChangePercentage24H.transformToPercentString()
        self.marketCapRank = String(coinData.marketData.marketCapRank)
        self.marketCapChangePercentage24H = coinData.marketData.marketCapChangePercentage24H.transformToPercentString()
        
    }
}
