//
//  SelectedTopicCollectionViewCell.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 31/08/23.
//

import UIKit

class SelectedTopicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedTopicLabel: UILabel!
    override func awakeFromNib() {
        selectedTopicLabel.text = "sample"
    }
}
