//
//  Location.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/3/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import UIKit
import Parse
import Firebase

typealias Location = PFGeoPoint

extension PFGeoPoint {
    
    
    @nonobjc static let LATITUDE_KEY = "Latitude"
    @nonobjc static let LONGITUDE_KEY = "Longitude"
    
    convenience init(data: [String: AnyObject]){
        self.init()
        self.longitude = data[Location.LONGITUDE_KEY] as! Double
        self.latitude = data[Location.LATITUDE_KEY] as! Double
    }
    
    func toDictionary() -> [String: AnyObject]{
        return [Location.LONGITUDE_KEY:self.longitude,
            Location.LATITUDE_KEY: self.latitude]
    }
    
    func updateOnFirebase(withUser user: User){
        let firebaseRef = Firebase(url: user.firebaseLocationPath)
        firebaseRef.setValue(self.toDictionary())
    }
    
    
}
