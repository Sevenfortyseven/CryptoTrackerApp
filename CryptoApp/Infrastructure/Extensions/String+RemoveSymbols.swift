//
//  String+RemoveHTML.swift
//  CryptoApp
//
//  Created by aleksandre on 10.02.22.
//

import Foundation


extension String {
    
    /// Remove occurances from string
    public var removeOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    
}
