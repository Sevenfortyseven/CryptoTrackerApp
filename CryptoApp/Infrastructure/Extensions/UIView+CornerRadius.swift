//
//  UIView+CornerRadius.swift
//  CryptoApp
//
//  Created by aleksandre on 05.02.22.
//

import Foundation
import UIKit


extension UIView {
    
    /// Returns self corner with medium curve
    public var mediumCurve: CGFloat? {
        self.layer.cornerRadius = self.frame.width / 15
        return nil
    }
    
    /// Returns self corner with small curve
    public var smallCurve: CGFloat? {
        self.layer.cornerRadius = self.frame.width / 30
        return nil
    }
    
}
