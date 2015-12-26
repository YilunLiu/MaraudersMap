//
//  NSDate+StringConversion.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/26/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import Foundation

extension NSDate{
    
    func toFullString() -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return formatter.stringFromDate(self)
    }
    
    class func fromString(string: String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return formatter.dateFromString(string)!
    }
}