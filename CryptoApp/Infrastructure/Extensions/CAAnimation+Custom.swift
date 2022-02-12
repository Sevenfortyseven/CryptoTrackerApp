//
//  CATransition+Custom.swift
//  CryptoApp
//
//  Created by aleksandre on 12.02.22.
//

import Foundation
import QuartzCore

extension CAAnimation {
    
    /// Custom Transition animation
    static var customTransition: CATransition {
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        transition.type = .fade
        return transition
    }
    
}
