//
//  LocationService.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/5/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Firebase
import CocoaLumberjackSwift

class LocationService{
    
    static var map = [String: LocationService]()
    static func LocationServiceForUser(user: User) -> LocationService{
        if map[user.objectId!] == nil {
            map[user.objectId!] = LocationService(user: user)
        }
        return map[user.objectId!]!
    }
    static func updateLocationForCurrentUser(location: Location){
        if let user = User.currentUser() {
            user.location = location
//            DDLogInfo("Sending Location update: \(location)")
            LocationServiceForUser(user).updateLocation(location)
            location.updateOnFirebase(withUser: user)
        }
    }
    
    let user: User
    let locationSignal: Signal<Location, NSError>
    let updateTimeSignal: Signal<NSDate, NSError>
    private let locationObserver: Observer<Location, NSError>
    private let updateTimeObserver: Observer<NSDate, NSError>
    
    private init(user: User){
        self.user = user
        let (signal, observer) = Signal<Location, NSError>.pipe()
        self.locationSignal = signal
        self.locationObserver = observer
        
        let (timeS, timeO) = Signal<NSDate, NSError>.pipe()
        self.updateTimeSignal = timeS
        self.updateTimeObserver = timeO
        
        if (user != User.currentUser()){
            
            
            Firebase(url: user.firebaseLocationPath).observeEventType(.Value, withBlock:{
                snapshot in
                if !(snapshot.value is NSNull){
                    DDLogInfo("Location Received: \(snapshot.value)")
                    
                    let data = snapshot.value as! [String:AnyObject]
                    let location = Location(data: data)
                    self.updateLocation(location)

                }
            })
        }
    }
    
    func updateLocation(location: Location){
        self.locationObserver.sendNext(location)
        self.updateTimeObserver.sendNext(NSDate())
    }
    
    

}