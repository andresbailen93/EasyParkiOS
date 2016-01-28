//
//  ParkZoneFree.swift
//  EasyPark
//
//  Created by INFTEL 13 on 27/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit

class ParkZoneFree{
    
    // MARK: Properties
    
    var numberFree: String?
    var image: UIImage?
    var nombre: String?
    
    
    init(numberFree:String?, image: String?, nombre: String?){
        
        self.numberFree = numberFree
        self.image = UIImage(named: image!)
        self.nombre = nombre
    }
    
}
