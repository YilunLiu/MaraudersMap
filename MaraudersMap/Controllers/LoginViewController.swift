//
//  SigninViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 11/1/15.
//  Copyright © 2015 RobotCat. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
import Parse
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    // MARK: - Target & Action
    @IBAction func signupButtonPressed(sender: AnyObject) {
        guard let presentingVC = self.presentingViewController else{
            self.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("SignupViewController"), animated: true, completion: nil)
            return
        }
        presentingVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signinButtonPressed(sender: AnyObject) {
        guard let phoneNumber = phoneNumberField.text else{
            return
        }
        
        guard let password = passwordField.text else {
            return
        }
        
        
        User.logInWithUsernameInBackground(phoneNumber, password: password)
            {(user: PFUser?, error:NSError?) in
            if let user = user {
                DDLogInfo("User Logged in with user \(user)")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController = storyBoard.instantiateInitialViewController()!
                UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
            }
                
            else {
                DDLogError("Sign with Log in, Error: \(error)")
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}