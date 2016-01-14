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
    static let LOCATION_KEY = "Location"
    static let LAST_LOCATION_UPDATED_KEY = "LastLocationUpdateTime"
    static let FIREBASE_USER_URL = "/users"
    
    var firebaseUserPath: String {
        get {
            return FIRE_BASE_URL+User.FIREBASE_USER_URL+"/"+self.objectId!
        }
    }
    
    var firebaseGroupPath: String{
        get {
            return self.firebaseUserPath+"/groups"
        }
    }
    
    var firebaseLocationPath: String{
        get {
            return self.firebaseUserPath+"/location"
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
    
    var friends: PFRelation{
        get{
            return relationForKey(User.FRIENDS_KEY)
        }
    }
    
    var location: Location?{
        get{
            return objectForKey(User.LOCATION_KEY) as? Location
        }
        set(newValue){
            self.lastLocationUpdatedTime = NSDate()
            setObject(newValue!, forKey: User.LOCATION_KEY)
        }
    }
    
    var lastLocationUpdatedTime: NSDate?{
        get {
            return objectForKey(User.LAST_LOCATION_UPDATED_KEY) as? NSDate
        }
        set (newValue){
            setObject(newValue!, forKey: User.LAST_LOCATION_UPDATED_KEY)
        }
    }
    
    func addAFriend(user: User){
        self.friends.addObject(user)
    }
    
    func removeAFriend(user: User){
        self.friends.removeObject(user)
    }
}