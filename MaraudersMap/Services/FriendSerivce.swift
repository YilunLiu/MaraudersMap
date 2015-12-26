//
//  FriendSerivce.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/26/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import CocoaLumberjackSwift
import Parse

class FriendService {
    
    static let defaultInstance = FriendService()
    
    let friendsSignal: Signal<[User],NSError>
    private let friendsObserver: Observer<[User],NSError>
    
    private init(){
        let (signal, observer) = Signal<[User], NSError>.pipe()
        self.friendsSignal = signal
        self.friendsObserver = observer
    }
    
    func fetchFriendsList(){
        let localQuery = self.friendQuery()
        localQuery.fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) in
            if error == nil{
                if let friends = objects as? [User]{
                    self.friendsObserver.sendNext(friends)
                }
            } else {
                DDLogError("FriendService: Local fetch with error: \(error)")
            }
        }
        
        let internetQuery = self.friendQuery()
        internetQuery.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) in
            if error == nil{
                if let friends = objects as? [User]{
                    self.friendsObserver.sendNext(friends)
                }
            } else {
                DDLogError("FriendService: Internet fetch with error: \(error)")
            }
        }
    }
    
    private func friendQuery() -> PFQuery{
        let query = User.currentUser()!.friends.query()
        query.orderByAscending(User.NICK_NAME_KEY)
        return query
    }
    
    
}