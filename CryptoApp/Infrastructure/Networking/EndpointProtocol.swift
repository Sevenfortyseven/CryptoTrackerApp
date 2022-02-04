//
//  EndpointProtocol.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation

protocol Endpoint {
    
    var scheme: String { get }
    
    var baseURL: String { get }
        
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: String { get }
}
