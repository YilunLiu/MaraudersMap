//
//  GroupsService.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/26/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse
import CocoaLumberjackSwift

class GroupsService{
    
    static let defaultInstance = GroupsService()
    
    let groupsSignal: Signal<[Group],NSError>
    var isFetching = false
    private let groupsObserver: Observer<[Group], NSError>
    
    private init(){
        let (groupsSignal, groupsObserver) = Signal<[Group],NSError>.pipe()
        self.groupsSignal = groupsSignal
        self.groupsObserver = groupsObserver
        
    }
    
    func createGroup(members members: [User], withName name: String){
        let group = Group(members: members)
        group.name = name
        group.saveInBackgroundWithBlock{
            (isSuccess: Bool, error: NSError?) in
            if isSuccess{
                group.pinInBackgroundWithBlock{
                    (_, _) in
                    self.fetchGroups()
                }
            }
            else {
                DDLogError("GroupsService, create group failed, error: \(error)")
            }
            
        }
    }
   
    func fetchGroups(){
        
        if isFetching {return}
        self.isFetching = true
        
        let localQuery = self.query()
        localQuery.fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock{
            (groups: [PFObject]?, error: NSError?) in
            if error == nil{
                let groups = groups as! [Group]
                self.groupsObserver.sendNext(groups)
            }
        }
        
        let internetQuery = self.query()
        internetQuery.findObjectsInBackgroundWithBlock{
            (groups: [PFObject]?, error: NSError?) in
            if error == nil{
                let groups = groups as! [Group]
                for group in groups {
                    group.pinInBackground()
        
                    for user in group.members{
                        user.pinInBackground()
                    }
                }
                self.groupsObserver.sendNext(groups)
                self.isFetching = false
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