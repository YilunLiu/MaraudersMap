//
//  SigninViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import UIKit
import ParseUI
import CocoaLumberjackSwift

class SignupViewController: PFSignUpViewController, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.signUpView?.logo = UIImageView(image: UIImage(named: "Logo"))
        self.delegate = self
        self.minPasswordLength = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - PFLogInViewControllerDelegate
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        DDLogError("User failed to sign up with error \(error)")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        DDLogInfo("User signed in with user \(user)")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyBoard.instantiateInitialViewController()!
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [String : String]) -> Bool {
        return true
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
    }

}
