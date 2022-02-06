//
//  GlobalDataDTO.swift
//  CryptoApp
//
//  Created by aleksandre on 06.02.22.
//

import Foundation


struct GlobalDataDTO: Codable {
    
    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int
    let markets: Int
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    let updatedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case upcomingIcos = "upcoming_icos"
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }
}

struct GlobalData {

    let totalMarketCap: String

    init(_ globalData: GlobalDataDTO) {
        /// obtain ony usd value
        if let currency = globalData.totalMarketCap.first(where: { $0.key == "usd" }) {
            self.totalMarketCap = String(currency.value)
        } else {
            self.totalMarketCap = ""
        }
        
    }
    
    
}
