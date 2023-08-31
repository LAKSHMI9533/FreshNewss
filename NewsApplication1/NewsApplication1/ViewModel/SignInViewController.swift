//
//  SignInViewController.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 29/08/23.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var user: String = ""
            
    // MARK: - View Loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action:#selector(navRegisterPage(sender:)))
        registerLabel.addGestureRecognizer(tap)
                
        user = userNameTextField.text!
    }
            
    /// To navigate to register page
    /// - Parameter sender: Gester Recogniser
    @objc func navRegisterPage(sender:UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
        self.present(vc, animated: true)
//        if let register = storyboard.instantiateViewController(withIdentifier: "RegisterVC") {
//            navigationController?.pushViewController(register, animated: true)
//        }
    }
            
        // MARK: - Button Action Methods
    @IBAction func onLoginClick(_ sender: Any) {
                user = userNameTextField.text ?? ""
        let valid = validateLogin(userNameInput: userNameTextField.text!, passwordInput: passwordTextField.text!)
        if valid {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pc = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController")
//            pc.presentationStyle = .fullScreen
            self.present(pc, animated: true)
//                pc.loginObj = self
        }
    }
}
