//
//  ViewController.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 23/08/23.
//

import UIKit
import Combine

class MainNewsViewController: UIViewController {
    
    @IBOutlet var tapGester: UITapGestureRecognizer!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 5
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource=self
        NewsCollectionView.delegate = self
        NewsCollectionView.dataSource = self
        NewsCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    @IBAction func tapGesterclicked(_ sender: Any) {
        print("mainviewcontroller")
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
                // NewsCollectionView.reloadData()
        }else{
            print("potrait")
                //NewsCollectionView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ApiCall()
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
                return 10
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
            cell.imageView.image = UIImage(named: "math-83288")
            
            return cell
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
                cell.contentLabel.text = "\(decodedResponce.articles[indexPath.row].content ?? "data not found come")\n\n PublishedAt  :       \((decodedResponce.articles[indexPath.row].publishedAt ?? "") as String ?? "")\n Author   :  \((decodedResponce.articles[indexPath.row].author ?? "") as String ?? "")"
                
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
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
//
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            
            if cell != prev{
                if let p = prev{
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
                var a = networking.addingCatToUrl(category: categoryEnum.allCases[indexPath.row])
                ApiCall(urll: a)
                
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
        print("layout")
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
    
    
}
