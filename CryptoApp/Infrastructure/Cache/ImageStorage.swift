//
//  ImageStorage.swift
//  CryptoApp
//
//  Created by aleksandre on 04.02.22.
//

import Foundation

struct ImageStorage {
    
    static var imageData = [String : Data]()
    
    static func getImageData(_ url: String, data: Data?) {
        imageData[url] = data
    }
    
    static func setImageData(_ url: String) -> Data? {
        return imageData[url]
    }
}
