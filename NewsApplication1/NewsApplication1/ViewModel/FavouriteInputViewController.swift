//
//  LanguageViewController.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 29/08/23.
//

import UIKit

class FavouriteInputViewController: UIViewController {
    @IBOutlet weak var favouriteInputCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

extension FavouriteInputViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categoryArray.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavouriteInputCollectionViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        cell.layer.cornerRadius = 20
        cell.favCategoryLabel.text = categoryArray[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20)/2
        return CGSize(width: size, height: size/3)
    }
    
    
}

