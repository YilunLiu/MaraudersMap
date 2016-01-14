//
//  UIColor+RandomColor.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/11/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static func randomColor() -> UIColor{
        let randR = CGFloat(random() % 256) / 256.0
        let randG = CGFloat(random() % 256) / 256.0
        let randB = CGFloat(random() % 256) / 256.0
        return UIColor(red: randR, green: randG, blue: randB, alpha: 1.0)
    }
}