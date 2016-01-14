//
//  GroupSettingViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/11/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import UIKit

class GroupSettingViewController: UITableViewController {

    
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabbarController = self.tabBarController as! GroupTabBarController
        self.group = tabbarController.group
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Target & Action
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
