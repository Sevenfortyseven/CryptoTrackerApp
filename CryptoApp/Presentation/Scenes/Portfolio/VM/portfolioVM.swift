//
//  portfolioVM.swift
//  CryptoApp
//
//  Created by aleksandre on 12.02.22.
//

import Foundation


class PortfolioViewModel {
    
    // MARK: - Public
    
    var globalData: ObservableObject<GlobalData?> = ObservableObject(value: nil)
    
    
    init(_ globalData: GlobalData) {
        self.globalData.value = globalData
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Private
    
}
