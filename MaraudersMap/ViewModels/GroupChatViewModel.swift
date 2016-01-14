//
//  GroupChatViewModel.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/13/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import Foundation

import Foundation
import ReactiveCocoa
import Firebase
import CocoaLumberjackSwift

class GroupChatViewModel: NSObject{
    
    
    let group: Group
    let groupService: GroupService
    
    let messages = MutableProperty<[Message]>([Message]())
    let lastMessage = MutableProperty<Message>(Message())
    let lastUpdatedTime: MutableProperty<NSDate>
    let groupName: ConstantProperty<String>
    
    
    init(group: Group) {
        self.group = group
        self.groupService = GroupService.GroupServiceWithGroup(group)
        self.groupName = ConstantProperty<String>(group.name)
        self.lastUpdatedTime = MutableProperty<NSDate>(group.lastMessageTime)
        super.init()
        
        self.groupService.messageSignal.observeOn(QueueScheduler.mainQueueScheduler)
            .observeNext{
                [weak self] message in
                self?.messages.value.append(message)
                self?.lastMessage.value = message
        }
    }
    
    deinit{
        DDLogDebug("GroupChatViewModel for group(\(self.group.objectId!)) is deallocated")
    }
    
}