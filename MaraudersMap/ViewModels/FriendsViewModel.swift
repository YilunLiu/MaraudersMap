//
//  FriendsViewModel.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/26/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import CocoaLumberjackSwift
import Parse

class FriendsViewModel: NSObject {

    let friends = MutableProperty<[User]>([User]())
    let friendsSignal: Signal<[User], NSError>
    
    private let friendService = FriendService.defaultInstance
    
    override init(){
        self.friendsSignal = self.friendService.friendsSignal
        super.init()
        
        self.friendsSignal.observeOn(QueueScheduler.mainQueueScheduler)
        .observeNext{
            (friends: [User]) in
            self.friends.value = friends
        }
    }
    
    func reloadFriends(){
        self.friendService.fetchFriendsList()
    }
    
}
