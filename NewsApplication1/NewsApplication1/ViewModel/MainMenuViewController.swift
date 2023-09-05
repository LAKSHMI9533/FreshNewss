//
//  MainMenuViewController.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 27/08/23.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController{
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var tapGester: UITapGestureRecognizer!
    @IBOutlet var MenuTableView: UITableView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in:.none)
                print(position.x)
                print(position.y)
            }
    }
     
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    override func viewDidLoad() {
        let userEntity1 = Entity(context: PersistentStorage.shared.persistentContainer.viewContext)
        userEntity1.favArray = FavArray as NSObject
        PersistentStorage.shared.saveContext()
        
        MenuTableView.rowHeight = MenuTableView.bounds.height/9
        MenuTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        self.view.frame.size.width = UIScreen.main.bounds.width/2
        self.view.layer.cornerRadius = 7
        self.view.layer.borderWidth = 1
    }
}

extension MainMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuTableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.menuItemLabel.text = menuArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuArray[indexPath.row] == "View Profile" {
            if !isGuest {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pc = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                self.present(pc, animated: true)
            } else {
                let alert = UIAlertController(title: "", message: "Please login to see your profile.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        } else if menuArray[indexPath.row] == "Contact Us" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC")
            self.present(pc, animated: true)
        } else if menuArray[indexPath.row] == "SavedNews" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pc = storyboard.instantiateViewController(withIdentifier: "MarkedNews")
            self.present(pc, animated: true)
        } else {
            if menuArray[indexPath.row] == "Log Out" {
                let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to Log out?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    print("log out")
                    menuArray[indexPath.row] = "Log In"
                    FavArray = ["Business","Entertainment"]
                    isGuest = true
                    tableView.reloadData()
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            } else {
                isFromSideMenuLogin = true
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                self.present(pc, animated: true)
                menuArray[indexPath.row] = "Log Out"
                isGuest = false
                tableView.reloadData()
            }
        }
        
        MenuTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
