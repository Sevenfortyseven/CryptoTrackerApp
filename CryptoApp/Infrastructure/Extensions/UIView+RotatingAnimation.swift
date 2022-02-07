//
//  UIView+RotatingAnimation.swift
//  CryptoApp
//
//  Created by aleksandre on 06.02.22.
//

import Foundation
import UIKit

extension UIView {
    
    /// Rotating animation
    public func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = 0
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
