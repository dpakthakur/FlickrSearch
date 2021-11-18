//
//  HttpManager.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 17/11/21.
//

import UIKit

enum Result<T> {
    case success(T)
    case failure(String)
    case error(String)
}

class HttpManager: NSObject {
    
    static let shared = HttpManager()
    
    func request(_ request: Request, completion: @escaping (Result<Data>) -> Void) {
        
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return completion(.failure(Constants.noInternetConnection))
        }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                return completion(.failure(error!.localizedDescription))
            }
            
            guard let data = data else {
                return completion(.failure(error?.localizedDescription ?? Constants.errorMessage))
            }
            
            guard let stringResponse = String(data: data, encoding: String.Encoding.utf8) else {
                return completion(.failure(error?.localizedDescription ?? Constants.errorMessage))
            }
            
            print("Respone: \(stringResponse)")
            
            return completion(.success(data))
            
        }.resume()
    }
    
    func downloadImage(_ urlString: String, completion: @escaping (Result<UIImage>) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        guard let url =  URL.init(string: urlString) else {
            return completion(.failure(Constants.errorMessage))
        }
        
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return completion(.failure(Constants.noInternetConnection))
        }
        
        session.downloadTask(with: url) { (url, reponse, error) in
            do {
                guard let url = url else {
                    return completion(.failure(Constants.errorMessage))
                }
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    return completion(.success(image))
                } else {
                    return completion(.failure(Constants.errorMessage))
                }
            } catch {
                return completion(.error(Constants.errorMessage))
            }
            }.resume()
        
    }
}
