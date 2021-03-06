//
//  GroupService.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import Firebase
import ReactiveCocoa
import CocoaLumberjackSwift

class GroupService {
    
    private let group: Group
    private let messageURL: String
    private let firebaseRef: Firebase
    let messageProducer: SignalProducer<Message, NSError>
    let messageObserver: Observer<Message, NSError>
    
    static var map = [String: GroupService]()
    
    static func GroupServiceWithGroup(group: Group) -> GroupService {
        if map[group.objectId!] == nil{
            map[group.objectId!] = GroupService(group: group)
        }
        return map[group.objectId!]!
    }
    
    private init(group: Group){
        self.group = group
        self.messageURL = Message.FB_MESSAGE_URL + "/" + group.objectId!
        self.firebaseRef = Firebase(url: self.messageURL)
        self.firebaseRef.keepSynced(true)
        
        let (signalProducer, observer) = SignalProducer<Message, NSError>.buffer()
        self.firebaseRef.observeEventType(.ChildAdded){
            (snapshot: FDataSnapshot!) in
            if !(snapshot.value is NSNull){
                DDLogInfo("Message Received: \(snapshot.value)")
                
                var data = snapshot.value as! [String:AnyObject]
                data[Message.ID_KEY] = snapshot.key
                
                let message = Message(data: data)
                group.lastMessageTime = message.createdAt
                observer.sendNext(message)
            }
        }
        self.messageProducer = signalProducer
        self.messageObserver = observer
        
    }
    
}