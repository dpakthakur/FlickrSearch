//
//  FlickrImage.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 17/11/21.
//

import UIKit

struct FlickrImage: Codable {
    
    let title: String
    let farm : Int
    let server : String
    let id : String
    
    let isfamily : Int
    let isfriend : Int
    let ispublic : Int
    
    let owner: String
    let secret : String
    
    var imageURL: String {
        let urlString = String(format: Constants.imageURL, farm, server, id, secret)
        return urlString
    }
}

struct Photos: Codable {
    let photo: [FlickrImage]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
}

struct PhotosSearchResults: Codable {
    let stat: String?
    let photos: Photos?
}

