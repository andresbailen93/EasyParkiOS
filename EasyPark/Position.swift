//
//  Position.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit
import CoreLocation


class Position{

// MARK: Properties
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var date: NSDate
    var direction: String?
    var city: String?
    var country: String?
    
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, date: NSDate, direction: String?, city: String?, country: String?){
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.direction = direction
        self.city = city
        self.country = country
        
    }
    
    //init() {}
}
