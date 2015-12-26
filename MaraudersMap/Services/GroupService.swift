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
    let messageSignal: Signal<Message, NSError>
    let messageObserver: Observer<Message, NSError>
    
    init(group: Group){
        self.group = group
        self.messageURL = Message.FB_MESSAGE_URL + "/" + group.objectId!
        self.firebaseRef = Firebase(url: self.messageURL)
        self.firebaseRef.keepSynced(true)
        
        let (signal, observer) = Signal<Message, NSError>.pipe()
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
        self.messageSignal = signal
        self.messageObserver = observer
        
    }
    
}