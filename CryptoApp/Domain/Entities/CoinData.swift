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
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case description
        case image
        case marketData = "market_data"
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
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
    let priceChangePercentage60D: Double
    let sparkline7D: Sparkline7D
    let marketCapChangePercentage24H: Double
    let totalVolume: [String: Double]
    let high24H: [String: Double]
    let low24H: [String: Double]
    let priceChange24H: Double
    let marketCapChange24H: Double
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case sparkline7D = "sparkline_7d"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage60D = "price_change_percentage_60d"
        case marketCapChange24H = "market_cap_change_24h"
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
    let priceChangePercentage60D: String
    let marketCapRank: String
    let marketCapChangePercentage24H: String
    let totalVolume: String
    let highestPriceIn24H: String
    let lowestPriceIn24H: String
    let priceChangeIn24H: String
    let marketCapChange24H: String
    let blockTimeInMinutes: String
    let hashingAlgorithm: String
    
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
        if let highestPriceIn24HInUSD = coinData.marketData.high24H.first(where: { $0.key == "usd" }) {
            self.highestPriceIn24H = "$" + highestPriceIn24HInUSD.value.transformToCurrencyWith6Decimals()
        } else {
            self.highestPriceIn24H = ""
        }
        if let lowestPriceIn24HInUSD = coinData.marketData.low24H.first(where: { $0.key == "usd" }) {
            self.lowestPriceIn24H = "$" + lowestPriceIn24HInUSD.value.transformToCurrencyWith6Decimals()
        } else {
            self.lowestPriceIn24H = ""
        }
        
        self.sparkLine7D = coinData.marketData.sparkline7D.price
        self.coinName = coinData.name
        self.imageURL = coinData.image.small

        self.overview = coinData.description.en.removeOccurances
        self.priceChangePercentage60D = coinData.marketData.priceChangePercentage60D.transformToPercentString()
        self.marketCapRank = String(coinData.marketData.marketCapRank)
        self.marketCapChangePercentage24H = coinData.marketData.marketCapChangePercentage24H.transformToPercentString()
        self.priceChangeIn24H = coinData.marketData.priceChange24H.transformToCurrencyWith6Decimals()
        self.priceChangePercentage24H = coinData.marketData.priceChangePercentage24H.transformToPercentString()
        self.marketCapChange24H = coinData.marketData.marketCapChange24H.formattedWithAbbreviations()
        
        if let blockTimeInMinutes = coinData.blockTimeInMinutes {
            self.blockTimeInMinutes = String(blockTimeInMinutes) + " Min"
        } else {
            self.blockTimeInMinutes = "No Data"
        }
        
        self.hashingAlgorithm = coinData.hashingAlgorithm ?? "No Data"
    }
}
