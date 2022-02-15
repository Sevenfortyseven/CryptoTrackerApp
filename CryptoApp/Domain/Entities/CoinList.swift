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
    let id: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Int?
    let priceChangePercentage24H: Double?

    
    enum CodingKeys: String, CodingKey {
        case symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case id
    }
}


struct CoinList {
    
    let name: String
    let symbol: String
    let imageURL: String
    let currentPrice: Double
    let priceChangePercentage24H: Double?
    let marketCapRank: Int
    let id: String
    var isOwned: Bool
    var holdings: Int
}

