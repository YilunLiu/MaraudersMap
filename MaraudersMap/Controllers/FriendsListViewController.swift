//
//  FriendsListViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/26/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Parse
import CocoaLumberjackSwift

class FriendsListViewController: UITableViewController {
    
    var friendsViewModel: FriendsViewModel!
    
    private var disposables = [Disposable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsViewModel = FriendsViewModel()
        let disposable = self.friendsViewModel.friends.producer.startWithNext{
            _ in
            self.tableView.reloadData()
        }
        self.friendsViewModel.reloadFriends()
        self.disposables.append(disposable)
    }
   
    
    // MARK: - TableView Datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsViewModel.friends.value.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friend = self.friendsViewModel.friends.value[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = friend.nickName
        return cell
    }
    
    
    
    // MARK: - Target & Action
    @IBAction func addButtonPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add A Friend", message: "Enter phone number", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .Default){ action in
            guard let textField = alertController.textFields?.first else {
                return
            }
            
            guard let phoneNumber = textField.text else {
                return
            }
            
            let query = User.query()!
            query.whereKey(User.PHONE_NUMBER_KEY, equalTo: phoneNumber)
            query.getFirstObjectInBackgroundWithBlock{
                (object: PFObject?, error: NSError?) in
                if let user = object as? User{
                    DDLogInfo("FriendsListViewController: Find user: \(user)")
                    User.currentUser()!.addAFriend(user)
                    User.currentUser()?.saveInBackgroundWithBlock{
                        (_, _) in
                        self.friendsViewModel.reloadFriends()
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}