//
//  LanguageViewController.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 29/08/23.
//

import UIKit

class FavouriteInputViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var navBarBackButton: UIBarButtonItem!
    @IBOutlet weak var favouriteInputCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onNavBarBackButtonClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onDoneButtonClick(_ sender: Any) {
        self.dismiss(animated: true)
        
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
        cell.layer.cornerRadius = 20
        cell.favCategoryLabel.text = categoryArray[indexPath.row]
        
        print(categoryArray[indexPath.row])
        for item in FavArray {
            print(categoryArray[indexPath.row], item)
            if categoryArray[indexPath.row] ==  item {
                cell.backgroundColor = UIColor(named: "background color")
                break
            } else {
                cell.backgroundColor =  UIColor.secondarySystemBackground
            }
        }
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20)/2
        return CGSize(width: size, height: size/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FavouriteInputCollectionViewCell
        
        if cell.backgroundColor == UIColor.secondarySystemBackground {
            cell.backgroundColor = UIColor(named: "background color")
            FavArray.append(cell.favCategoryLabel.text!)
        } else {
            let index = FavArray.firstIndex(of:cell.favCategoryLabel.text!)
            FavArray.remove(at: index ?? Int())
            cell.backgroundColor = UIColor.secondarySystemBackground
        }

    }
    
}

