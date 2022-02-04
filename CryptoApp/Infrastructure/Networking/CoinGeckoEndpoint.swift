//
//  CoinGeckoEndpoint.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation

enum CoinGeckoEndpoint: Endpoint {
    
case CoinList
    
    var scheme: String {
        switch self {
        default: return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default: return "api.coingecko.com"
        }
    }
    
    var path: String {
        switch self {
        case .CoinList: return "/api/v3/coins/markets"
        }
    }
    
    var parameters: [URLQueryItem] {
        let vsCurrency = "vs_currency"
        let descending = "market_cap_desc"
        let priceChangePercentage = "price_change_percentage"
        let resultsPerPage = "per_page"
        
        switch self {
        case .CoinList: return [URLQueryItem(name: vsCurrency, value: "usd"),
                               URLQueryItem(name: "order", value: descending),
                               URLQueryItem(name: priceChangePercentage, value: "24h"),
                               URLQueryItem(name: resultsPerPage, value: "200"),
                               URLQueryItem(name: "page", value: "1")
                               ]
        }
    }
    
    var method: String {
        switch self {
        default: return "GET"
        }
    }
    
}