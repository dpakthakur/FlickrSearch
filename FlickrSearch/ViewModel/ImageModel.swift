//
//  ImageModel.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 18/11/21.
//

import Foundation

struct ImageModel {
    let imageURL: String
    init(withPhotos photo: FlickrImage) {
        imageURL = photo.imageURL
    }
}
