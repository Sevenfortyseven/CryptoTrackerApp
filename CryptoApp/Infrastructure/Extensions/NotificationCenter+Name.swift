//
//  NotificationCenter+Name.swift
//  CryptoApp
//
//  Created by aleksandre on 06.02.22.
//

import Foundation

extension Notification.Name {
    
    static let refreshData = Notification.Name("refreshData")
    
    static let reorderByRank = Notification.Name("reorderByRank")
    
    static let reorderByPrice = Notification.Name("reorderByPrice")
}
