//
//  ParkZone.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import Foundation
import UIKit



class ParkZone{
    
    // MARK: Properties

    var floor: String?
    var section: String?
    var number: String?
    var photo: UIImage?
    
    
    init(floor: String?, section:String?, number:String?, photo: String?){
        let filledStarImage = UIImage(named: photo!)
        self.floor = floor
        self.section = section
        self.number = number
        self.photo = filledStarImage
        
    }
    
        
}