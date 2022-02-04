//
//  NetworkEngine.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation

class NetworkEngine {
    
    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.host = endpoint.baseURL
        urlComponents.queryItems = endpoint.parameters
        urlComponents.path = endpoint.path
        urlComponents.scheme = endpoint.scheme
        
        guard let url = urlComponents.url else {
            print("problem with given url:  \(String(describing: urlComponents.url))")
            return
        }
        print("url is: \(url)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown Error")
                return
            }
            guard let data = data, response != nil else { return }
            
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                if let responseObject = try? decoder.decode(T.self, from: data) {
                    completion(.success(responseObject))
                } else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
