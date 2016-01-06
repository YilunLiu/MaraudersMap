//
//  GroupListViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import UIKit
import CocoaLumberjackSwift

class GroupListViewController: UITableViewController {

    var groupsViewModel = GroupsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsViewModel.groups.producer.startWithNext({
            _ in
            self.tableView.reloadData()
        })
        groupsViewModel.reloadGroups()
    }
    
    // MARK: - TableView Datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsViewModel.groups.value.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath)
        let group = groupsViewModel.groups.value[indexPath.row]
        cell.textLabel?.text = group.name
        return cell
    }
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let group = groupsViewModel.groups.value[indexPath.row]
        let groupController = self.storyboard?.instantiateViewControllerWithIdentifier("GroupTabBarController") as! GroupTabBarController
        groupController.group = group
        
        self.presentViewController(groupController, animated: true, completion: nil)
    }
    
    
}
