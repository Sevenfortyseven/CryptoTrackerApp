//
//  UIImage+Rotation.swift
//  CryptoApp
//
//  Created by aleksandre on 05.02.22.
//

import UIKit

extension UIImageView {
    
    /// Animate 180c rotation 
    public func rotateBy180(_ shouldRotate: Bool) {
        UIView.animate(withDuration: 0.4) {
            switch shouldRotate {
            case true:
                self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            case false:
                self.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }
        }
        
    }
}
