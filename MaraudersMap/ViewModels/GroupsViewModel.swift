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
    
    let groups = MutableProperty<[Group]>([Group]())
    private let groupsService = GroupsService.defaultInstance
    
    override init(){
        super.init()
        
        self.groupsService.groupsSignal.observeOn(QueueScheduler.mainQueueScheduler)
            .observeNext{
                (groups:[Group]) in
                self.groups.value = groups
        }
        
    }
    
    
    // MARK: - HELPER

    func reloadGroups(){
        self.groupsService.fetchGroups()
    }
    
}