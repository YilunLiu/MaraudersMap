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
    static func LocationServiceForUser(user: User){
        
    }
    
    let user: User
    let locationSignal: Signal<Location, NSError>
    private let locationObserver: Observer<Location, NSError>
    
    private init(user: User){
        self.user = user
        let (signal, observer) = Signal<Location, NSError>.pipe()
        self.locationSignal = signal
        self.locationObserver = observer
        
        Firebase(url: user.firebaseLocationPath).observeSingleEventOfType(.Value, withBlock:{
            snapshot in
            if !(snapshot.value is NSNull){
                DDLogInfo("Location Received: \(snapshot.value)")
                
                let data = snapshot.value as! [String:AnyObject]
                let location = Location(data: data)
                self.locationObserver.sendNext(location)
            }
        })
        
    }
    
    func updateLocation(location: Location){
        location.updateOnFirebase(withUser: self.user)
    }
    
    

}