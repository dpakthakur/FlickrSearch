//
//  SearchService.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 18/11/21.
//

import UIKit

enum RequestConfig {
    case searchRequest(String, Int)
    var value: Request? {
      switch self {
        case .searchRequest(let searchText, let pageNo):
            let urlString = String(format: Constants.searchURL, searchText, pageNo)
            let reqConfig = Request.init(requestMethod: .get, urlString: urlString)
            return reqConfig
        }
    }
}

class SearchService: NSObject {
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        guard let request = RequestConfig.searchRequest(searchText, pageNo).value else {
            return
        }
        
        HttpManager.shared.request(request) { (result) in
            switch result {
            case .success(let responseData):
                if let model = self.getDecodedResponse(responseData) {
                    if let stat = model.stat, stat.uppercased().contains("OK") {
                        return completion(.success(model.photos))
                    } else {
                        return completion(.failure(Constants.errorMessage))
                    }
                } else {
                    return completion(.failure(Constants.errorMessage))
                }
            case .failure(let message):
                return completion(.failure(message))
            case .error(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func getDecodedResponse(_ data: Data) -> PhotosSearchResults? {
        do {
            let responseModel = try JSONDecoder().decode(PhotosSearchResults.self, from: data)
            return responseModel
            
        } catch {
            print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}

