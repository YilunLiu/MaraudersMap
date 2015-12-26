//
//  SignupViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 11/1/15.
//  Copyright © 2015 RobotCat. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
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
    
    @IBAction func signinButtonPressed(sender: AnyObject) {
        guard let viewController = self.presentingViewController else{
            self.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController"), animated: true, completion: nil)
            return
        }
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        guard let username = usernameField.text else{
            return
        }
        
        guard let phoneNumber = phoneNumberField.text else {
            return
        }
        
        guard let password = passwordField.text else {
            return
        }
        
        let user = User()
        user.username = phoneNumber
        user.phoneNumber = phoneNumber
        user.nickName = username
        user.password = password
        
        user.signUpInBackgroundWithBlock{(isSuccess: Bool, error:NSError?) in
            if isSuccess {
                DDLogInfo("User Logged in with user \(user)")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController = storyBoard.instantiateInitialViewController()!
                UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
            }
                
            else {
                DDLogError("Sign up failed, error: \(error)")
            }
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.editing = false
        return true
    }
}
