//
//  MarketDTO.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation

typealias CoinListDTOResponse = [CoinListDTO]

struct CoinListDTO: Codable {
    
    let symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank: Int
    let high24H, low24H : Double
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H : Double
    let marketCapChangePercentage24H: Double
    let totalSupply: Double?
    let maxSupply: Double?
    
    enum CodingKeys: String, CodingKey {
        case symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
    }
}


struct CoinList {
    
    let name: String
    let symbol: String
    let imageURL: String
    let currentPrice: Double
    let priceChangePercentage24H: Double?
    let marketCapRank: Int

}

