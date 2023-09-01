//
//  ContactUsViewController.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 31/08/23.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextField.text = "Hello User!\n We are the team of FlashNews \n This application is intended to deliver the Latest news of different categories to the user\n \n You can contact us at UWorld Ind Pvt Ltd, Hyderabad, India."
    }


}
