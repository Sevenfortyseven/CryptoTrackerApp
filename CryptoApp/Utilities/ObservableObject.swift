//
//  ObservableObject.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation

class ObservableObject<T> {
    
    var value: T? {
        didSet {
            guard let value = value else {
                print("value is missing")
                return
            }
            listener?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    var listener: ((T) -> Void)?
    
    
    func bind(listener: @escaping ((T) -> Void)) {
        listener(value!)
        self.listener = listener
    }
}
