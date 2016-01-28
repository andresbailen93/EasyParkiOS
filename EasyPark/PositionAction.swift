//
//  PositionAction.swift
//  EasyPark
//
//  Created by INFTEL 13 on 26/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PositionAction{
    
    static func deletePosition(position: Position){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(position)
        
        do{
            try managedContext.save()
        }catch let error as NSError {
            print("No se pudo borrar \(error), \(error.userInfo)")
        }

    }
    
    static func savePosition(direction: String,city: String, country: String, latitude: Double, longitude: Double, date: NSDate) ->Bool{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Position", inManagedObjectContext: managedContext)
        
        let position = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Position
        
        position.direction = direction
        position.city = city
        position.country = country
        position.latitude = latitude
        position.longitude = longitude
        position.date = date
        
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("No se pudo guardar \(error), \(error.userInfo)")
            return false
        }
        
    }
    static func viewLastPosition()->(bool: Bool,position: Position?){
        var positions = [Position]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Position")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            positions = results as! [Position]
            
            if positions.count == 0{
                return (false, nil)
            }else{
                return(true, positions[0])
            }

        } catch let error as NSError {
            print("No se pudo encontrar nada \(error), \(error.userInfo)")
            return(false, nil)
        }
    }
    
    static func viewAllPositions()->[Position]?{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        let fetchRequest = NSFetchRequest(entityName: "Position")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
             return results as? [Position]
            
        } catch let error as NSError {
            print("No se pudo encontrar nada \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    static func getDateFormatted(positionDate: NSDate) ->String{
        let formater = NSDateFormatter()
        formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let myDate = "Fecha: " + formater.stringFromDate(positionDate)
        return myDate

        
    }
    
    
}
