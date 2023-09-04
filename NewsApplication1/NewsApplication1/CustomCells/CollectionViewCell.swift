//
//  CollectionViewCell.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 23/08/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var markedButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        
        imageView.isUserInteractionEnabled = false
        titleLabel.sizeToFit()
        contentLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        // Initialization code
    }

}
