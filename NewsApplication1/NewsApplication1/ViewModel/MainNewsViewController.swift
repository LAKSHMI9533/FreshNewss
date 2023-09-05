//
//  ViewController.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 23/08/23.
//

import UIKit
import Combine
import CoreData

class MainNewsViewController: UIViewController {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var NewsCollectionView: UICollectionView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var homeButton: UIButton!
    var refresh = UIRefreshControl()
    var can =  Set<AnyCancellable>()
    var networking = Networking()
    var decodedResponce : Responce!
    var prev : UICollectionViewCell!
    var markedArray : [Int] = []
    var model = MainNewsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiCall()
        let myColor : UIColor = UIColor.white
        //.layer.borderColor = myColor.cgColor
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.borderColor = UIColor(named: "background color")?.cgColor
        searchTextField.layer.cornerRadius = 15
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource=self
        NewsCollectionView.delegate = self
        NewsCollectionView.dataSource = self
        NewsCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }

    @IBAction func MenuButtonClicked(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TableViewCell")
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func SearchButtonClicked(_ sender: Any) {
        if searchTextField.text !=  ""{
            let temp = searchUrl + "\(searchTextField.text!)"
            ApiCall(urll: temp)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("rotated")
        if UIDevice.current.orientation.isLandscape{
            print("landscape")
                viewDidLoad()
        }else{
            print("potrait")
                viewDidLoad()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ApiCall()
    }
   
    
    func ApiCall(urll:String = ""){
        if urll == ""{
            networking.apiCall().sink { error in
                print(error)
            } receiveValue: { decodedResponce1 in
                self.decodedResponce = decodedResponce1
                print(decodedResponce1.articles.count)
                DispatchQueue.main.async {
                    self.NewsCollectionView.reloadData()
                }
            }.store(in: &can)
        } else {
            networking.apiCall(catApiUrl: urll).sink { error in
                print(error)
            } receiveValue: { decodedResponce1 in
                self.decodedResponce = decodedResponce1
                DispatchQueue.main.async {
                    self.NewsCollectionView.reloadData()
                    self.dismiss(animated: false, completion: nil)
                }
            }.store(in: &can)
        }
    }
}


extension MainNewsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView{
            return categoryArray.count
        }else{
            if  (decodedResponce != nil){
                return decodedResponce.articles.count
            } else {
                return 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView{
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
            cell.textLabel.sizeToFit()
            return cell
        }else{
            let cell = NewsCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.shareButton.tag = indexPath.row
            cell.markedButton.tag = indexPath.row
            cell.markedButton.setImage(UIImage(systemName: "square.and.arrow.down")
                                       , for: UIControl.State.normal)
            var fetchingResponce = model.fetching(titleToSearch: decodedResponce.articles[indexPath.row].title!)
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
        
    }
    @objc func MarkedButtonTapped(_ sender:UIButton){
        let image1 = UIImage(systemName: "square.and.arrow.down")
        let image2 = UIImage(systemName: "square.and.arrow.down.fill")

        let buttond = sender
        if buttond.currentImage == image2{
            var aa = model.fetching(titleToSearch: decodedResponce.articles[sender.tag].title!)
            print(aa)
            if aa != nil{
                model.DeleteOperation(ob: aa.first!)
            }
            sender.setImage(image1, for: UIControl.State.normal)
            
        }else{
            markedArray.append(sender.tag)
            print(markedArray)
            sender.setImage(image2, for: UIControl.State.normal)
            let markedNews = Marked(context: PersistentStorage.shared.persistentContainer.viewContext)

            markedNews.author = (decodedResponce.articles[sender.tag].author ?? "") as String
            markedNews.context = (decodedResponce.articles[sender.tag].content ?? "") as String
            markedNews.descript12 = (decodedResponce.articles[sender.tag].description ?? "") as String
            markedNews.publishedAt = (decodedResponce.articles[sender.tag].publishedAt ?? "") as String
            markedNews.title = (decodedResponce.articles[sender.tag].title ?? "") as String
            markedNews.url = (decodedResponce.articles[sender.tag].url ?? "") as String
            markedNews.urlToImage = (decodedResponce.articles[sender.tag].urlToImage ?? "") as String
            PersistentStorage.shared.saveContext()

        }
        
        
    }
    
    
    @objc func buttonTapped(_ sender: UIButton){
        print(sender.tag)
        var dataToShare = " "
        dataToShare.append("Articles: \((decodedResponce.articles[sender.tag].url ?? "\(decodedResponce.articles[sender.tag].content)" ) as String)")
        
        let activityVC = UIActivityViewController(activityItems: [dataToShare], applicationActivities: nil)
//            activityVC.excludedActivityTypes = [.addToReadingList, .openInIBooks, .print]
        let button = sender as UIView
//        let cell = button.nearestAncestor(ofType: CollectionViewCell.self),

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

                // 5. set the activityVC to nil after the user is done
//                DispatchQueue.main.async { [weak self] in
//                    self?.activityVC = nil
//                }
         //   }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 1
        
        if collectionView == categoryCollectionView{
            let cell = cell as! CategoryCollectionViewCell
            cell.textLabel.text = "  \(categoryArray[indexPath.row])   "
            cell.textLabel.sizeToFit()
            
        }else{
            
            let cell = cell as! CollectionViewCell
    
            var activityView: UIActivityIndicatorView?
            activityView = UIActivityIndicatorView(style: .large)
            activityView?.frame = cell.imageView.bounds
            activityView?.color = .systemPink

            if  (decodedResponce != nil){
                cell.imageView.image = nil
                cell.imageView.addSubview(activityView!)
                activityView?.startAnimating()
                
                cell.descriptionLabel.text = "\(decodedResponce.articles[indexPath.row].description ?? "data not found ")"
                cell.titleLabel.text = "\(decodedResponce.articles[indexPath.row].title ?? "data not found")"
                cell.contentLabel.text = "\(decodedResponce.articles[indexPath.row].content ?? "data not found come")\n\n PublishedAt   :   \((decodedResponce.articles[indexPath.row].publishedAt ?? "") as String )\n Author   :  \((decodedResponce.articles[indexPath.row].author ?? "") as String )"
                
                if decodedResponce.articles[indexPath.row].urlToImage != nil {
                    DispatchQueue.main.async {
                        
                        self.networking.apiCallForImage(uurl: self.decodedResponce.articles[indexPath.row].urlToImage!).sink { error in
                            print(error)
                        } receiveValue: { Responce in
                            DispatchQueue.main.async {
                                activityView?.stopAnimating()
                                cell.imageView.image = Responce
                                print("imageattached\(indexPath)")
                            }
                        }.store(in: &self.can)
                    }
                }else{
//                    activityView?.stopAnimating()
                }
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            
            if cell != prev{
                if let temp = prev{
                    prev.backgroundColor = nil
                }
                cell.backgroundColor = .brown
                if(cell.isSelected)
                {
                    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.style = UIActivityIndicatorView.Style.medium
                    loadingIndicator.startAnimating();
                    
                    alert.view.addSubview(loadingIndicator)
                    present(alert, animated: true, completion: nil)
                }
                else
                {
                    cell.backgroundColor = .blue
                }
                prev = cell
                let urlForCategory = networking.addingCatToUrl(category: categoryEnum.allCases[indexPath.row])
                ApiCall(urll: urlForCategory)
                
            }else{
//                cell.backgroundColor = nil
            }
        } else {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "webViewController") as! WebViewController
            vc.urlForNews = "\((decodedResponce.articles[indexPath.row].url ?? "notfound url") as String)"
            if let vcc = vc.presentationController as? UISheetPresentationController{
                vcc.detents = [.medium(),.large()]
            }
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
}
extension MainNewsViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemWidth = collectionView.bounds.width
        var itemHeight = collectionView.bounds.height
        
        if collectionView == categoryCollectionView{
            itemWidth = collectionView.bounds.width - 5
            itemHeight = collectionView.bounds.height - 5
            print(collectionView)
        }
        
            return CGSize(width: itemWidth, height: itemHeight)
        }
    
    
}
