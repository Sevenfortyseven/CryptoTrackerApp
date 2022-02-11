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
    case coinData(id: String)
    
    
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
        case .coinData(let coinID): return "/api/v3/coins/\(coinID)"
        }
    }
    
    var parameters: [URLQueryItem]? {
        let vsCurrency            = "vs_currency"
        let priceChangePercentage = "price_change_percentage"
        let resultsPerPage        = "per_page"
        let descending            = "market_cap_desc"
        let localization          = "localization"
        let falseAsString         = "false"
        let trueAsString          = "true"
        let tickers               = "tickers"
        let marketData            = "market_data"
        let communityData         = "community_data"
        let developerData         = "developer_data"
        let sparkline             = "sparkline"
        
        switch self {
        case .CoinList: return [URLQueryItem(name: vsCurrency, value: "usd"),
                                URLQueryItem(name: "order", value: descending),
                                URLQueryItem(name: priceChangePercentage, value: "24h"),
                                URLQueryItem(name: resultsPerPage, value: "250"),
                                URLQueryItem(name: "page", value: "1")
                                ]
        case .coinData: return [URLQueryItem(name: localization, value: falseAsString),
                                URLQueryItem(name: tickers, value: falseAsString),
                                URLQueryItem(name: marketData, value: trueAsString),
                                URLQueryItem(name: communityData, value: trueAsString),
                                URLQueryItem(name: developerData, value: falseAsString),
                                URLQueryItem(name: sparkline, value: trueAsString)
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

