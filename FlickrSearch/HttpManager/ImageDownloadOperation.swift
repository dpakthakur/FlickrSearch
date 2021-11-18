//
//  ImageDownloadOperation.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 17/11/21.
//

import UIKit

typealias ImageCompletion = (_ image : UIImage?, _ url : String) -> Void

class ImageDownloadOperation: Operation {
    
    let url: String?
    var customCompletionBlock: ImageCompletion?
    
    init(url: String, completionBlock: @escaping ImageCompletion) {
        self.url = url
        self.customCompletionBlock = completionBlock
    }
    
    override func main() {
        
        if self.isCancelled { return }
        
        if let url = self.url {
        
            if self.isCancelled { return }
            
            HttpManager.shared.downloadImage(url) { (result) in
            
                ThreadClass.runOnMainThread {
                    switch result {
                    case .success(let image):
                        if self.isCancelled { return }
                        if let completion = self.customCompletionBlock{
                            completion(image, url)
                        }
                    default:
                        if self.isCancelled { return }
                        break
                    }
                }
            }
        }
    }
}
