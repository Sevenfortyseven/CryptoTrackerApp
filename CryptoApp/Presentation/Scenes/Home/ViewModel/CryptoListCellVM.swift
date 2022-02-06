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
    let currentPrice: String
    let priceChangePercentage24H: String
    let marketCapRank: String


    
    
    init(name: String, symbol: String, iconURL: String, currentPrice: Double, priceChangePercentage24H: Double, marketCapRank: Int) {
        self.name                     = name
        self.symbol                   = symbol.uppercased()
        self.iconURL                  = iconURL
        self.currentPrice             = currentPrice.transformToCurrencyWith6Decimals()
        self.priceChangePercentage24H = priceChangePercentage24H.transformToPercentString()
        self.marketCapRank            = String(marketCapRank)
        
    }
    

   
}
