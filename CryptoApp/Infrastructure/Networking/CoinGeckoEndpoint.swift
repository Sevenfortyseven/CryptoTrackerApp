//
//  CoinGeckoEndpoint.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation

enum CoinGeckoEndpoint: Endpoint {
    
    case CoinList
    case Global
    
    
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
        case .Global: return "/api/v3/global"
        }
    }
    
    var parameters: [URLQueryItem]? {
        let vsCurrency            = "vs_currency"
        let priceChangePercentage = "price_change_percentage"
        let resultsPerPage        = "per_page"
        let descending            = "market_cap_desc"
        
        switch self {
        case .CoinList: return [URLQueryItem(name: vsCurrency, value: "usd"),
                                           URLQueryItem(name: "order", value: descending),
                                           URLQueryItem(name: priceChangePercentage, value: "24h"),
                                           URLQueryItem(name: resultsPerPage, value: "250"),
                                           URLQueryItem(name: "page", value: "1")
        ]
        default: return nil
        }
    }
    
    var method: String {
        switch self {
        default: return "GET"
        }
    }
    
    
    
}

enum EndpointCustomParams: String {
    
    case descending = "market_cap_desc"
    case ascending  = "market_cap_asc"
    
}

