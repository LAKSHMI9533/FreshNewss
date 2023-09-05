//
//  FavNewsCollectionView.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 24/08/23.
//

import Foundation
import UIKit
import Combine

class FavNewsViewController: UIViewController{
    @IBOutlet var favNewsCollection: UICollectionView!
    var can =  Set<AnyCancellable>()
    var favDecodedResponce : Responce!
    var favresultsarray : String = ""
    var arrayforfav : [Responce] = []
    var arrayforfav1 : [results] = []
    var coount = 0
    var model = FavNewsViewModel()
    override func viewDidLoad() {
        favNewsCollection.delegate = self
        favNewsCollection.dataSource = self
        favNewsCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        for i in 0...FavArray.count-1{
            let a = addingCatToUrl(category: categoryEnum.allCases[i])
            ApiCall(urll: a)
        }
    }
    
    func ApiCall(urll:String = ""){
        if urll == ""{
            apiCall().sink { error in
                print(error)
            } receiveValue: { decodedResponce1 in
                self.favDecodedResponce = decodedResponce1
            }.store(in: &can)
        } else {
            apiCall(catApiUrl: urll).sink { error in
                print(error)
            } receiveValue: { [self] decodedResponce1 in
 
                self.arrayforfav.append(decodedResponce1)
                self.arrayforfav1.append(contentsOf: decodedResponce1.articles)
                arrayforfav1.shuffle()
                if arrayforfav.count == FavArray.count{
                    DispatchQueue.main.async {
                        self.favNewsCollection.reloadData()
                    }
                }
            }.store(in: &can)
        }
    }
    @objc func MarkedButtonTapped(_ sender:UIButton){
        let image1 = UIImage(systemName: "square.and.arrow.down")
        let image2 = UIImage(systemName: "square.and.arrow.down.fill")

        let buttond = sender
        if buttond.currentImage == image2{
            let aa = model.fetching(titleToSearch: arrayforfav1[sender.tag].title!)
            if aa.isEmpty == false{
                model.DeleteOperation(ob: aa.first!)
            }
            sender.setImage(image1, for: UIControl.State.normal)
            
        }else{

            sender.setImage(image2, for: UIControl.State.normal)
            let markedNews = Marked(context: PersistentStorage.shared.persistentContainer.viewContext)

            markedNews.author = (arrayforfav1[sender.tag].author ?? "") as String
            markedNews.context = (arrayforfav1[sender.tag].content ?? "") as String
            markedNews.descript12 = (arrayforfav1[sender.tag].description ?? "") as String
            markedNews.publishedAt = (arrayforfav1[sender.tag].publishedAt ?? "") as String
            markedNews.title = (arrayforfav1[sender.tag].title ?? "") as String
            markedNews.url = (arrayforfav1[sender.tag].url ?? "") as String
            markedNews.urlToImage = (arrayforfav1[sender.tag].urlToImage ?? "") as String
            PersistentStorage.shared.saveContext()

        }
        
        
    }
    @objc func buttonTapped(_ sender: UIButton){
        print(sender.tag)
        var dataToShare = " "
        dataToShare.append("Articles: \((arrayforfav1[sender.tag].url ?? "" ) as String)")
        
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


extension FavNewsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayforfav1.isEmpty{
            return 0
        } else {
            return arrayforfav1.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favNewsCollection.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.shareButton.tag = indexPath.row
        cell.markedButton.tag = indexPath.row
        cell.markedButton.setImage(UIImage(systemName: "square.and.arrow.down")
                                   , for: UIControl.State.normal)
        let fetchingResponce = model.fetching(titleToSearch: arrayforfav1[indexPath.row].title!)
        if fetchingResponce.isEmpty {
            cell.markedButton.setImage(UIImage(systemName: "square.and.arrow.down")
                                       , for: UIControl.State.normal)
        }else{
            cell.markedButton.setImage(UIImage(systemName: "square.and.arrow.down.fill")
                                       , for: UIControl.State.normal)
        }
        cell.shareButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.markedButton.addTarget(self, action: #selector(MarkedButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 1
        let cell = cell as! CollectionViewCell
        var activityView: UIActivityIndicatorView?
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.frame = cell.imageView.bounds
        activityView?.color = .systemPink
        if  (!arrayforfav1.isEmpty){
            cell.imageView.image  = nil
            if indexPath.row < arrayforfav1.count{
                if(arrayforfav1[indexPath.row] != nil){
                    cell.imageView.image = nil
                    cell.imageView.addSubview(activityView!)
                    activityView?.startAnimating()
                    
                    cell.descriptionLabel.text = "\(arrayforfav1[indexPath.row].description ?? "description not found")"
                    cell.titleLabel.text = "\(arrayforfav1[indexPath.row].title ?? "notfound")"
                    cell.contentLabel.text = "\(arrayforfav1[indexPath.row].content ?? "notfound")"
                    if arrayforfav1[indexPath.row].urlToImage != nil{
                        apiCallForImage(uurl: arrayforfav1[indexPath.row].urlToImage!).sink { error in
                            print(error)
                        } receiveValue: { Responce in
                            DispatchQueue.main.async {
                                activityView?.stopAnimating()
                                cell.imageView.image = Responce
                                print("imageattached\(indexPath)")
                            }
                        }.store(in: &can)
                    }
                }else {
                    print("empty")
                }
            }else{
                print("error in will display")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "webViewController") as! WebViewController
        vc.urlForNews = "\((arrayforfav1[indexPath.row].url ?? "notfound url") as String)"
        if let vcc = vc.presentationController as? UISheetPresentationController{
            vcc.detents = [.medium(),.large()]
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension FavNewsViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemWidth = collectionView.bounds.width - 10
            let itemHeight = collectionView.bounds.height - 100
            return CGSize(width: itemWidth, height: itemHeight)
        }
}
