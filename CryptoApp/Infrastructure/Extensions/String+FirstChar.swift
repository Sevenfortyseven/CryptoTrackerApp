//
//  String+FirstChar.swift
//  CryptoApp
//
//  Created by aleksandre on 05.02.22.
//

import Foundation


extension String {
    
    
    ///Returns the first character of the given string
    public func getFirstChar() -> Character {
        let firstIndex = self.startIndex
        let firstCharacter: Character = self[firstIndex]
        return firstCharacter
    }
}
