//
//  Message.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import Parse

class Message: NSObject, JSQMessageData {
    
    static let FB_MESSAGE_URL = FIRE_BASE_URL + "/messages"
    
    static let ID_KEY = "ID"
    static let GROUPID_KEY = "GroupID"
    static let AUTHORID_KEY = "AuthorID"
    static let CREATED_AT_KEY = "CreatedAt"
    static let CONTENT_KEY = "Content"
    static let AUTHOR_NAME_KEY = "AuthorName"
    
    var id: String!
    let createdAt: NSDate
    let authorId: String
    let groupId: String
    let authorName: String
    var content: String
    var author: User?
    
    override init() {
        self.createdAt = NSDate()
        self.content = ""
        self.authorId = ""
        self.groupId = ""
        self.authorName = ""
        super.init()
    }
    
    init(data: AnyObject){
        self.id = data[Message.ID_KEY] as! String
        self.groupId = data[Message.GROUPID_KEY] as! String
        self.authorId = data[Message.AUTHORID_KEY] as! String
        self.createdAt =  NSDate.fromString(data[Message.CREATED_AT_KEY] as! String)
        self.content = data[Message.CONTENT_KEY] as! String
        self.authorName = data[Message.AUTHOR_NAME_KEY] as! String
        super.init()
    }
   
    // MARK: - JSQMessageData Protocal
    func text() -> String! {
        return self.content
    }
    
    func senderId() -> String! {
        return self.authorId
    }
    
    func senderDisplayName() -> String! {
        return self.authorName
    }
    
    func date() -> NSDate! {
        return self.createdAt
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func messageHash() -> UInt {
        return UInt(self.hash)
    }
    

}
