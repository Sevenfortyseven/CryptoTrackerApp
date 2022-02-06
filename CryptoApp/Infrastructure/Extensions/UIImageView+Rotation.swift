//
//  UIImage+Rotation.swift
//  CryptoApp
//
//  Created by aleksandre on 05.02.22.
//

import UIKit

extension UIImageView {
   
    public func rotateBy180() {
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
}
