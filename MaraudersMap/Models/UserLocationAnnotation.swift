//
//  UserLocationAnnotation.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/12/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import Foundation

class UserLocationAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    let userId: String
    
    init(location: Location, user: User){
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.userId = user.objectId!
    }
}