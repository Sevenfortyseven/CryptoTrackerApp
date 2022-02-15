//
//  CryptoListCellVM.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation


struct CryptoCellViewModel {
    
    let name: String
    let symbol: String
    let iconURL: String
    let currentPriceAsString: String
    let currentPrice: Double
    let priceChangePercentage24H: String
    let marketCapRank: String
    var holdingsCount: Int?
    var holdingsValue: Double?

    
    
    init(name: String, symbol: String, iconURL: String, currentPrice: Double, priceChangePercentage24H: Double, marketCapRank: Int, holdingsCount: Int?, holdingsValue: Double?) {
        self.name                     = name
        self.symbol                   = symbol.uppercased()
        self.iconURL                  = iconURL
        self.currentPriceAsString     = currentPrice.transformToCurrencyWith6Decimals()
        self.priceChangePercentage24H = priceChangePercentage24H.transformToPercentString()
        self.marketCapRank            = String(marketCapRank)
        self.currentPrice             = currentPrice
        self.holdingsCount            = holdingsCount
        self.holdingsValue            = holdingsValue
    }
    

   
}
