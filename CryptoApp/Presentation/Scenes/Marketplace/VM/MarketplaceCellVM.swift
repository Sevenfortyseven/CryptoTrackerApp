//
//  MarketplaceCellVM.swift
//  CryptoApp
//
//  Created by aleksandre on 13.02.22.
//

import Foundation


struct MarketplaceCellViewModel {
    
    let imageURL: String
    let coinName: String
    let coinID: String
    let coinPrice: String
    let coinPriceDouble: Double?
    
    
    init(imageURL: String, coinName: String, coinID: String, coinPrice: Double) {
        self.imageURL  = imageURL
        self.coinName  = coinName
        self.coinID    = coinID.uppercased()
        self.coinPrice = coinPrice.transformToCurrencyWith6Decimals()
        self.coinPriceDouble =  coinPrice
    }
}
