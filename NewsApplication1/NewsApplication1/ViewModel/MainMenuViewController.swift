//
//  MainMenuViewController.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 27/08/23.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController{
    
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
    
    override func viewDidLoad() {
        let userEntity1 = Entity(context: PersistentStorage.shared.persistentContainer.viewContext)
        userEntity1.favArray = FavArray as NSObject
        PersistentStorage.shared.saveContext()
        print(userEntity1.favArray as! [ String])
        //        let transition = CATransition()
//        transition.duration = 2
//        transition.type = CATransitionType.reveal
//        transition.subtype = CATransitionSubtype.fromRight
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        self.view.layer.add(transition, forKey: kCATransition)

        MenuTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
    }
    override func updateViewConstraints() {
        self.view.frame.size.width = UIScreen.main.bounds.width/2
        self.view.layer.cornerRadius = 7
        self.view.layer.borderWidth = 1
        super.updateViewConstraints()
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pc = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
            self.present(pc, animated: true)
        } else if menuArray[indexPath.row] == "Contact Us" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC")
            self.present(pc, animated: true)
        } else {
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to Log out?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                print("log out")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        
        MenuTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}