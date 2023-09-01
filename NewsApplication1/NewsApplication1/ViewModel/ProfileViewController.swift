//
//  ProfileViewController.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 31/08/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileIconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var selectedTopicCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTopicCollectionView.delegate = self
        selectedTopicCollectionView.dataSource = self
        profileIconImage.layer.cornerRadius = profileIconImage.frame.width/2
        selectedTopicCollectionView.isUserInteractionEnabled = false
        
        print(FavArray)
        selectedTopicCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(FavArray)
        selectedTopicCollectionView.reloadData()
    }
    

}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectedTopicCollectionViewCell

        cell.backgroundColor = .blue
        cell.layer.borderWidth = 1
        cell.layer.borderColor =  UIColor.gray.cgColor
        cell.layer.backgroundColor =  UIColor.secondarySystemBackground.cgColor
        cell.layer.cornerRadius = 20
//
        cell.selectedTopicLabel.text = FavArray[indexPath.row]
//        cell.selectedTopicLabel.backgroundColor = .brown
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20)/2
        return CGSize(width: size, height: size/4)
    }
    
    
}
