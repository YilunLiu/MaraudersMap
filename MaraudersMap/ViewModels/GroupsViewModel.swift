//
//  GroupsViewModel.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse

class GroupsViewModel: NSObject {
    
    static let defaultInstance = GroupsViewModel()
    
    private override init(){
        super.init()
        
    }
    
    let groups = MutableProperty<[Group]>([Group]())
    
    func reloadGroups(){
        
        let localQuery = self.query()
        localQuery.fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock{
            (groups: [PFObject]?, error: NSError?) in
            if error == nil{
                let groups = groups as! [Group]
                self.groups.value = groups
            }
        }
        
        let internetQuery = self.query()
        internetQuery.findObjectsInBackgroundWithBlock{
            (groups: [PFObject]?, error: NSError?) in
            if error == nil{
                let groups = groups as! [Group]
                self.groups.value = groups
                for group in groups {
                    group.pinInBackground()
                }
            }
        }
    }
    
    // MARK: - HELPER
    private func query() -> PFQuery{
        let query = Group.query()!
        query.whereKey(Group.MEMBERS_KEY, equalTo: User.currentUser()!)
        query.includeKey(Group.MEMBERS_KEY)
        query.orderByDescending(Group.LAST_MESSAGE_TIME_KEY)
        return query
    }
    
}