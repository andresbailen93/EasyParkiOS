//
//  Position.swift
//  EasyPark
//
//  Created by Andrés Bailén Jiménez on 26/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class Position: NSManagedObject{
    
    // MARK: Properties
    @NSManaged var latitude: CLLocationDegrees
    @NSManaged var longitude: CLLocationDegrees
    @NSManaged var date: NSDate
    @NSManaged var direction: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    
}