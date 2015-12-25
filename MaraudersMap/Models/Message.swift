//
//  Message.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import Parse

class Message: NSObject {
    
    static let FB_MESSAGE_URL = FIRE_BASE_URL + "\\messages"
    
    static let ID_KEY = "ID"
    static let GROUPID_KEY = "GroupID"
    static let AUTHORID_KEY = "AuthorID"
    static let CREATED_AT_KEY = "CreatedAt"
    static let CONTENT_KEY = "Content"
    
    var id: String!
    let createdAt: NSDate
    let authorId: String
    let groupId: String
    var content: String
    
    override init() {
        self.createdAt = NSDate()
        self.content = ""
        self.authorId = ""
        self.groupId = ""
        super.init()
    }
    
    init(data: AnyObject){
        self.id = data[Message.ID_KEY] as! String
        self.groupId = data[Message.GROUPID_KEY] as! String
        self.authorId = data[Message.AUTHORID_KEY] as! String
        self.createdAt = data[Message.CREATED_AT_KEY] as! NSDate
        self.content = data[Message.CONTENT_KEY] as! String
        super.init()
    }
    
    convenience init(content: String){
        self.init()
        self.content = content
    }
    
    
}
