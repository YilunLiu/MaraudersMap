//
//  GroupViewModel.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Firebase

class GroupViewModel: NSObject{
    
    
    let group: Group
    let groupService: GroupService
    
    let messages = MutableProperty<[Message]>([Message]())
    let lastMessage = MutableProperty<Message>(Message())
    let lastUpdatedTime: MutableProperty<NSDate>
    let groupName: ConstantProperty<String>
    
    init(group: Group) {
        self.group = group
        self.groupService = GroupService(group: group)
        self.groupName = ConstantProperty<String>(group.name)
        self.lastUpdatedTime = MutableProperty<NSDate>(group.lastMessageTime)
        super.init()
        
        self.groupService.messageSignal.observeOn(QueueScheduler.mainQueueScheduler)
            .observeNext{
                message in
                self.messages.value.append(message)
                self.lastMessage.value = message
                self.lastUpdatedTime.value = message.createdAt
        }
    }
    
    
    
    
    
}