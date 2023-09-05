//
//  ContactUsViewController.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 31/08/23.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let attributedString = NSMutableAttributedString()
        let normalText = NSAttributedString(string: "Hello User! \nWe are the team of ", attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        attributedString.append(normalText)

        let boldText  = "Flash News."
        let boldString = NSMutableAttributedString(string: boldText, attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])

        attributedString.append(boldString)
        
        let remString = NSMutableAttributedString(string: " This application is intended to deliver the Latest news of different categories to the user\n \nYou can contact us at UWorld Ind Pvt Ltd, Hyderabad, India. \n\nVisit our Website: ", attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        attributedString.append(remString)
        
        let visitOurWebsite = NSMutableAttributedString(string: "Link\n\n", attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        let visitUrl = URL(string: "https://www.uworld.com")
        visitOurWebsite.setAttributes([.link: visitUrl!], range: NSMakeRange(0, 4))
        attributedString.append(visitOurWebsite)
        
        let emailLink = NSMutableAttributedString(string: "Mail to Us: Email", attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        let url = URL(string: "https://mail.google.com/mail/u/0/#inbox?compose=new")
        emailLink.setAttributes([.link: url!], range: NSMakeRange(12, 5))
        attributedString.append(emailLink)
        descriptionTextView.attributedText = attributedString
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.isEditable = false
        
        // Set how links should appear: blue and underlined
        descriptionTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 18)
        ]

    }

    @IBAction func onBackButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
