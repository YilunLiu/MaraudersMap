//
//  User.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation
import Parse

class User: PFUser{

    static let PHONE_NUMBER_KEY = "PhoneNumber"
    static let NICK_NAME_KEY = "NickName"
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    
    var phoneNumber: String {
        get {
            return objectForKey(User.PHONE_NUMBER_KEY) as! String
        }
        set (newValue){
            setObject(newValue, forKey: User.PHONE_NUMBER_KEY)
        }
    }
    
    var nickName: String {
        get {
            return objectForKey(User.NICK_NAME_KEY) as! String
        }
        set (newValue){
            setObject(newValue, forKey: User.NICK_NAME_KEY)
        }
    }
}