//
//  SignUpViewController.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 29/08/23.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let obj = RegisterViewModel()
        obj.fetchUser()
    
        submitButton.backgroundColor = .gray
        submitButton.isEnabled = false
        phoneNoTextField.allTargets.prefix(10)
    }
    
    // MARK: - Button Action Methods
    @IBAction func submitButtonOnClick(_ sender: Any) {
        var user = userDetails(userName: userNameTextField.text ?? "", firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", email: emailTextField.text ?? "", phoneNo: Int64(Int(phoneNoTextField.text ?? "") ?? 1), password: passwordTextField.text ?? "")
        
        let obj = RegisterViewModel()
        obj.CreateUser(user: &user)
    }

    // MARK: - TextFields Action Methods
    @IBAction func firstNameChanged(_ sender: Any) {
        if let firstName = firstNameTextField.text {
            if let errorMessage = validateFirstName(firstName) {
                firstNameLabel.text = errorMessage
                firstNameLabel.isHidden = false
            } else {
                firstNameLabel.isHidden = true
            }
        }
        checkValidInputs()
    }
    
    @IBAction func lastNameChanged(_ sender: Any) {
        if let lastName = lastNameTextField.text {
            if let errorMessage = validateLastName(lastName){
                lastNameLabel.text = errorMessage
                lastNameLabel.isHidden = false
            } else {
                lastNameLabel.isHidden = true
            }
        }
        checkValidInputs()
    }
    
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTextField.text {
            if let errorMessage = validateEmail(email) {
                emailLabel.text = errorMessage
                emailLabel.isHidden = false
            } else {
                emailLabel.isHidden = true
            }
        }
        checkValidInputs()
    }
    
    @IBAction func phoneNoChanged(_ sender: Any) {
        if let phoneNo = phoneNoTextField.text {
            if let errorMessage = validatePhoneNo(phoneNo) {
                phoneNoLabel.text = errorMessage
                phoneNoLabel.isHidden = false
            } else {
                phoneNoLabel.isHidden = true
            }
        }
        checkValidInputs()
    }
    
    @IBAction func userNameChanged(_ sender: Any) {
        if let userName = userNameTextField.text {
            if let errorMessage = validateUserName(userName) {
                userNameLabel.text = errorMessage
                userNameLabel.isHidden = false
            } else {
                userNameLabel.isHidden = true
            }
        }
        checkValidInputs()
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = passwordTextField.text {
            if let errorMessage = validatePassword(password) {
                passwordLabel.text = errorMessage
                passwordLabel.isHidden = false
            } else {
                passwordLabel.isHidden = true
            }
        }
        checkValidInputs()
    }
    
    // MARK: - Other Methods
    
    /// To enable user
    func checkValidInputs() {
        //
        if firstNameLabel.isHidden && lastNameLabel.isHidden && emailLabel.isHidden && phoneNoLabel.isHidden && userNameLabel.isHidden && passwordLabel.isHidden {
            self.submitButton.backgroundColor = .systemBlue
            submitButton.isEnabled = true
        } else {
            submitButton.backgroundColor = .gray
            submitButton.isEnabled = false
        }
    }

}
