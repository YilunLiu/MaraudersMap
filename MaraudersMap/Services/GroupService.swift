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

class GroupService {
    
    private let group: Group
    private let messageURL: String
    private let firebaseRef: Firebase
    let messageSignal: Signal<Message, NSError>
    let messageObserver: Observer<Message, NSError>
    
    init(group: Group){
        self.group = group
        self.messageURL = Message.FB_MESSAGE_URL + "\\" + group.objectId!
        self.firebaseRef = Firebase(url: self.messageURL)
        
        let (signal, observer) = Signal<Message, NSError>.pipe()
        self.firebaseRef.observeEventType(.Value){
            (snapshot: FDataSnapshot!) in
            let message = Message(data: snapshot.value)
            observer.sendNext(message)
            group.lastMessageTime = message.createdAt
        }
        self.messageSignal = signal
        self.messageObserver = observer
        
    }
    
}