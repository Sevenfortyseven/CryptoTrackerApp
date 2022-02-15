//
//  UpdateHoldingsDelegate.swift
//  CryptoApp
//
//  Created by aleksandre on 14.02.22.
//

import Foundation

protocol UpdateHoldingsDelegate: AnyObject {
    
    var totalHoldingsValue : Double? { get set }
    var updatedCoinList: [CoinList]? { get set }
}
