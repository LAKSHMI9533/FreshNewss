//
//  MarkedNews.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 05/09/23.
//

import Foundation
import UIKit
import CoreData
import Combine

class MarkedNewsViewController : UIViewController{
    @IBOutlet var backButton: UIButton!
    @IBOutlet var clearAllButton: UIButton!
    @IBOutlet var savedCollectionView: UICollectionView!
    var can =  Set<AnyCancellable>()
    var markedArray : [Int] = []
    var result1 : [Marked]?
    let model = MarkedNewsViewModel()
    
    override func viewDidLoad() {
        savedCollectionView.dataSource = self
        savedCollectionView.delegate = self
        result1 = model.fetching()
        
        savedCollectionView.reloadData()
        savedCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    @IBAction func BackButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func ClearAllButton(_ sender: Any) {
        if model.DeetingSearch(){
            result1 = model.fetching()
            savedCollectionView.reloadData()

        }
        
    }
    @objc func MarkedButtonTapped(_ sender:UIButton){
        let image1 = UIImage(systemName: "square.and.arrow.down")
        //let image2 = UIImage(systemName: "square.and.arrow.down.fill")
        let aa = model.fetching(titleToSearch: result1![sender.tag].title!)
        if aa.first != nil{
            model.DeleteOperation(ob: aa.first!)
            result1 = model.fetching()
            savedCollectionView.reloadData()
        }else{
            print("SEARCH WAS EMPTY")
        }
        sender.setImage(image1, for: UIControl.State.normal)
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        var dataToShare = " "
        dataToShare.append("Articles: \((result1?[sender.tag].url ?? "" ) as String)")
        let activityVC = UIActivityViewController(activityItems: [dataToShare], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender.superview
            if UIDevice.current.userInterfaceIdiom == .phone {
                activityVC.modalPresentationStyle = .overFullScreen
            }
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2 , width: 0, height: 0)

                activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        present(activityVC, animated: true, completion: nil)
            activityVC.completionWithItemsHandler = { [weak self](activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
        }
    }
}


extension MarkedNewsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (result1?.count == nil){
            return 0
        }else{
            return result1!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = savedCollectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.descriptionLabel.text = "\(result1?[indexPath.row].descript12 ?? "data not found ")"
        cell.titleLabel.text = "\(result1?[indexPath.row].title ?? "data not found")"
        cell.contentLabel.text = "\(result1?[indexPath.row].context ?? "data not found come")\n\n PublishedAt   :   \((result1?[indexPath.row].publishedAt ?? "") as String )\n Author   :  \((result1?[indexPath.row].author ?? "") as String )"
        cell.shareButton.tag = indexPath.row
        cell.markedButton.tag = indexPath.row
        cell.markedButton.setImage(UIImage(systemName: "square.and.arrow.down.fill")
                                   , for: UIControl.State.normal)
        cell.shareButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.markedButton.addTarget(self, action: #selector(MarkedButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CollectionViewCell
        var activityView: UIActivityIndicatorView?
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.frame = cell.imageView.bounds
        activityView?.color = .systemPink
        if  (result1 != nil){
            cell.imageView.image = nil
            cell.imageView.addSubview(activityView!)
            activityView?.startAnimating()
            if result1?[indexPath.row].urlToImage != nil {
                DispatchQueue.main.async {
                    apiCallForImage(uurl: (self.result1?[indexPath.row].urlToImage!)!).sink { error in
                        print(error)
                    } receiveValue: { Responce in
                        DispatchQueue.main.async {
                            activityView?.stopAnimating()
                            cell.imageView.image = Responce
                        }
                    }.store(in: &self.can)
                }
            }else{
//                    activityView?.stopAnimating()square.and.arrow.down
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = savedCollectionView.bounds.width
        let itemHeight = savedCollectionView.bounds.height-100
        return CGSize(width: itemWidth, height: itemHeight)
        }
    
}
