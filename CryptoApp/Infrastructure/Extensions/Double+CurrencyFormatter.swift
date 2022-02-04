//
//  Double+CurrencyFormatter.swift
//  CryptoApp
//
//  Created by aleksandre on 05.02.22.
//

import Foundation


extension Double {
    
    /// Converts Double into a Currency with 2-6 decimal places
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.minimumFractionDigits = 2
//        formatter.maximumFractionDigits = 6
//        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        return formatter
    }
    
    /// Converts Double into a Currency with 2-6 decimal places
    public func transformToCurrencyWith6Decimals() -> String {
        
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
     
    /// Converts Double into String
    private func transformToString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts String into PercentageString
    public func transformToPercentString() -> String {
        return transformToString() + "%"
    }
}
