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
    static let FRIENDS_KEY = "Friends"
    
    
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