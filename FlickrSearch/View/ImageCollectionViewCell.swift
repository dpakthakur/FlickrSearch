//
//  ImageCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 17/11/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let nibName = "ImageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
    
    var model: ImageModel? {
        didSet {
            if let model = model {
                imageView.image = UIImage(named: "placeholder")
                imageView.downloadImage(model.imageURL)
            }
        }
    }
}
