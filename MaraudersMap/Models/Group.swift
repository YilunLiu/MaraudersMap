//
//  Group.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import Parse
import Firebase

class Group: PFObject, PFSubclassing {
    
    static let MEMBERS_KEY = "Members"
    static let NAME_KEY = "Name"
    static let LAST_MESSAGE_TIME_KEY = "LastMessage"
    
    
    static func parseClassName() -> String {
        return "Group"
    }
    
    override init() {
        super.init()
    }
    
    convenience init(members: [User]){
        self.init()
        self.lastMessageTime = NSDate()
        self.name = ""
        self.setObject(members, forKey: Group.MEMBERS_KEY)
    }
    
    
    // MARK: - Variables
    var name: String {
        get {
            return objectForKey(Group.NAME_KEY) as! String
        }
        set (newValue){
            setObject(newValue, forKey: Group.NAME_KEY)
        }
    }
    
    var members: [User] {
        get{
            return objectForKey(Group.MEMBERS_KEY) as! [User]
        }
    }
    
    var lastMessageTime: NSDate{
        get{
            return objectForKey(Group.LAST_MESSAGE_TIME_KEY) as! NSDate
        }
        set(newValue){
            setObject(newValue, forKey: Group.LAST_MESSAGE_TIME_KEY)
        }
    }
    
    
    // MARK: - Members method
    func addMember(user: User){
        addUniqueObject(user, forKey: Group.MEMBERS_KEY)
    }
    
    func removeMember(user: User){
        removeObject(user, forKey: Group.MEMBERS_KEY)
    }
    
    func updateUsersGroupOnFB(){
        for member in self.members{
            let firebaseRef = Firebase(url: member.firebaseGroupPath)
            firebaseRef.updateChildValues([self.objectId!:true])
        }
    }
    
    
}