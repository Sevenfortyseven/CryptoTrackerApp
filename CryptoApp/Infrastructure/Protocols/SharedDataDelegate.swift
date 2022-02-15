//
//  SharedDataDelegate.swift
//  CryptoApp
//
//  Created by aleksandre on 14.02.22.
//

import Foundation

protocol SharedDataDelegate: AnyObject {
    
    var sharedData: [CryptoCellViewModel] { get set }
    var sharedHoldingsValue: Double { get set }
    
}
