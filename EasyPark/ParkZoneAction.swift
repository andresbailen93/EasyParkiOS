//
//  ParkZoneAction.swift
//  EasyPark
//
//  Created by INFTEL 13 on 28/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ParkZoneAction{

    static let urlWebService: String = "http://192.168.1.135:8080/RestEasyPark/webresources/modeloddbb.parkzone/"
    
 //------------------ ParkTableViewController -------------------
    static func loadCC(tableview: UITableViewController, nameCC: String){
        let tableC = tableview as! ParkTableViewController
        var cc: String
        var nameImage: String
        if nameCC == "ca" {
            cc = "freeCA"
            nameImage = "carrefour"
        }
        else {
            cc = "freeCI"
            nameImage = "corte"
            
        }
        
        let url = NSURL(string: urlWebService + cc)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if data != nil{

            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                //print(json)
                for var i = 0; i<json.count; i++ {
                    if let item = json[i]{
                        let nameC = item["centrocomercial"] as! String
                        let floor = item["planta"] as! String
                        let sect = item["seccion"] as! String
                        let number = item["numero"] as! String
                        let id_parkZone = item["idPlaza"] as! Int
                        
                        let free = ParkZone(name: nameC, floor: floor, section: sect, number: number , photo:nameImage, id_parkZone: id_parkZone)
                        tableC.parkZones += [free]
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    tableC.tableView.reloadData()
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            }
            
        }
        task.resume()
    }

    
    static func putBooking(tableview: UITableViewController, parkZone: ParkZone){
        
        let tableC = tableview as! ParkTableViewController
        
        let json = ["centrocomercial":parkZone.name,"idPlaza":parkZone.id_parkZone, "idUsuario": UIDevice.currentDevice().identifierForVendor!.UUIDString, "numero":parkZone.number,"ocupado":"1","planta":parkZone.floor,"seccion":parkZone.section]
        
        // create post request
        let d = String(parkZone.id_parkZone)
        var dataString:String = ""
        let url = NSURL(string: urlWebService + d)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        
        // insert json data to the reques
        
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
        }catch{
            print("error serializing JSON1: \(error)")
        }
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) in
            let httpResponse = response as? NSHTTPURLResponse
            print(httpResponse!.statusCode)
            
            if data != nil{

            dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            print(dataString)
            
            dispatch_async(dispatch_get_main_queue()) {
                if(dataString == "0"){
                    
                    tableC.showAlertReserved("Su plaza ha sido reservada correctamente")
                }else{
                    tableC.parkZones.removeAll()
                    tableC.showAlertReserved("ERROR al reservar plaza")
                }
            }
            }
            
        }
        
        task.resume()
    }
    
    //------------------ ParkFreeCCTableViewController ---------------
    
    static func readCountCarrefour(tableview: UITableViewController){
        let tableC = tableview as! ParkFreeCCTableViewController
        var dataString:String = ""
        
        let url = NSURL(string: urlWebService + "countCA")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if data != nil{
            dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            
            dispatch_async(dispatch_get_main_queue()) {
                tableC.ca.numberFree = dataString
                tableC.tableView.reloadData()
            }
            }
            
        }
        task.resume()
    }
    
    static func readCountCorteIngles(tableview: UITableViewController){
        let tableC = tableview as! ParkFreeCCTableViewController
        var dataString:String = ""
        
        let url = NSURL(string: urlWebService + "countCI")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if data != nil{

            dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            
            dispatch_async(dispatch_get_main_queue()) {
                tableC.ci.numberFree = dataString
                tableC.tableView.reloadData()
            }
            }
        }
        task.resume()
    }
    
    static func getUserParkZone(tableview: UITableViewController){
        let tableC = tableview as! ParkFreeCCTableViewController
        
        let idUser = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let url = NSURL(string: urlWebService + idUser)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if data != nil{
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if json.count > 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        tableC.showAlertReserved(json[0])
                    }
                }
                
            } catch {
                    print("error serializing JSON: \(error)")
            }
            }
        }
        task.resume()
    }
    
    static func putCancelBooking(parkZone: ParkZone){
        
        let json = ["centrocomercial":parkZone.name,"idPlaza":parkZone.id_parkZone, "idUsuario": "", "numero":parkZone.number,"ocupado":"0","planta":parkZone.floor,"seccion":parkZone.section]
        
        // create post request
        let d = String(parkZone.id_parkZone)
        
        let url = NSURL(string: urlWebService + d)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        
        // insert json data to the reques
        
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        }catch{
            print("error serializing JSON1: \(error)")
        }
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) in
            let httpResponse = response as? NSHTTPURLResponse
            print(httpResponse!.statusCode)
            
        }
        
        task.resume()
        
    }
    
    
}