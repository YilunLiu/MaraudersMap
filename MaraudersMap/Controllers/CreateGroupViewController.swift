//
//  CreateGroupViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/26/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let friendsViewModel = FriendsViewModel()
    var selectedUsers = [NSIndexPath: User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsViewModel.friends.producer.startWithNext({
            _ in
            self.tableView.reloadData()
        })
        self.friendsViewModel.reloadFriends()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController!.tabBar.hidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.friendsViewModel.friends.value.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendSelectionCell", forIndexPath: indexPath)
        let friend = friendsViewModel.friends.value[indexPath.row]
        cell.textLabel?.text = friend.nickName

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = (cell.accessoryType == .Checkmark) ? .None : .Checkmark
        cell.selected = false
        
        if (self.selectedUsers[indexPath] == nil){
            self.selectedUsers[indexPath] = self.friendsViewModel.friends.value[indexPath.row]
        } else {
            self.selectedUsers.removeValueForKey(indexPath)
        }
        
    }
    
    // MARK: - Target & Action
    @IBAction func completePressed(sender: AnyObject) {
        
        guard let name = nameField.text else {
            return
        }
        
        var users = Array(self.selectedUsers.values)
        users.append(User.currentUser()!)
        GroupsService.defaultInstance.createGroup(members: users, withName: name)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
