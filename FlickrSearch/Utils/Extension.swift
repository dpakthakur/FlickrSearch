//
//  Extension.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 17/11/21.
//

import UIKit

extension UICollectionView {
    func register(nib nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}

extension UIImageView {
    
    func downloadImage(_ url: String) {
        
        ImageDownloadManager.shared.addOperation(url: url,imageView: self) {  [weak self](result,downloadedImageURL)  in
            ThreadClass.runOnMainThread {
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure(_):
                    break
                case .error(_):
                    break
                }
            }
        }
    }
}
