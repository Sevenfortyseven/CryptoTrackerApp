//
//  UIImage+Fetching.swift
//  CryptoApp
//
//  Created by aleksandre on 04.02.22.
//

import UIKit

extension UIImageView {
    @discardableResult
    func loadImage(urlString: String, placeholder: UIImage? = nil) -> URLSessionDataTask? {
        self.image = nil
        
        if let cachedImage = ImageStorage.setImageData(urlString) {
            self.image = UIImage(data: cachedImage)
            return nil
        }
        
        guard let url = URL(string: urlString) else { return nil }
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async { [weak self] in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    ImageStorage.getImageData(url.absoluteString, data: data)
                    self?.image = downloadedImage
                }
            }
        }
        dataTask.resume()
        return dataTask
    }
    
}
