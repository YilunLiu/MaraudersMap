//
//  MeViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class MeViewController: UITableViewController {

    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = User.currentUser()?.nickName
        emailLabel.text = User.currentUser()?.phoneNumber
        profilePictureImageView.image = UIImage(named: "default_profile_picture")
    }
    
    
    @IBAction func logoutPressed(sender: AnyObject) {
        
        PFUser.logOut()
        let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
    }
    
    
}
