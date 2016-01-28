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

    var name: String!
    var floor: String!
    var section: String!
    var number: String!
    var photo: UIImage!
    var id_parkZone: Int!
    
    
    init(name: String!, floor: String!, section:String!, number:String!, photo: String!, id_parkZone: Int!){
        self.name = name
        self.floor = floor
        self.section = section
        self.number = number
        self.photo = UIImage(named: photo!)
        self.id_parkZone = id_parkZone
        
    }
    
        
}