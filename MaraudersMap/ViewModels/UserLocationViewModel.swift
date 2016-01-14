//
//  UserLocationViewModel.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/12/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import Foundation
import MapKit
import ReactiveCocoa

class UserLocationViewModel: NSObject{
    
    let color = ConstantProperty<UIColor>(UIColor.randomColor())
    let location = MutableProperty<Location?>(nil)
    let mapAnnotation = MutableProperty<UserLocationAnnotation?>(nil)
    let lastUpdateTime = MutableProperty<NSDate?>(nil)
    let locationService: LocationService
    let user: User
    
    
    init(user: User){
        self.user = user
        if let location = user.location{
            self.location.value = location
            self.lastUpdateTime.value = user.lastLocationUpdatedTime
            let annotation = UserLocationAnnotation(location: location, user: user)
            self.mapAnnotation.value = annotation
        }
        self.location.value = user.location
        self.locationService = LocationService.LocationServiceForUser(user)
        
        super.init()
        self.locationService.locationSignal.observeNext{
            [weak self] location in
            self?.location.value = location
            if self?.mapAnnotation.value == nil{
                let annotation = UserLocationAnnotation(location: location, user: user)
                self?.mapAnnotation.value = annotation
            }
            self?.mapAnnotation.value?.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        }
        
        self.locationService.updateTimeSignal.observeNext{
            [weak self] date in
            self?.lastUpdateTime.value = date
        }
    }
}