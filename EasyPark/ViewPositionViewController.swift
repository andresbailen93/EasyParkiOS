//
//  ViewPositionViewController.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class ViewPositionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    // MARK: Properties

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoDirection: UILabel!
    @IBOutlet weak var infoCity: UILabel!
    @IBOutlet weak var infoCountry: UILabel!
    @IBOutlet weak var infoDate: UILabel!
    
    var position: NSManagedObject?
    
    let locationManager = CLLocationManager()
    
    let longitude: CLLocationDegrees = 0.0
    let latitude: CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let position = position {
            infoDirection.text = "Dirección: " + (position.valueForKey("direction") as! String)
            infoCity.text = "Ciudad: " + (position.valueForKey("city") as! String)
            infoCountry.text = "País: " + (position.valueForKey("country") as! String)
            
            
            let formater = NSDateFormatter()
            formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myDate = "Fecha: " + formater.stringFromDate(position.valueForKey("date") as! NSDate)
            infoDate.text = myDate
            self.locationManager.startUpdatingLocation()
       
        }else{
            var positions = [NSManagedObject]()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "Position")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                positions = results as! [NSManagedObject]
                if(positions.count == 0){
                    
                    infoDirection.text = "Dirección: "
                    infoCity.text = "Ciudad: "
                    infoCountry.text = "País: "
                    infoDate.text = "Fecha: "
                    
                    
                }else{
                
                position = positions[0]
                
                infoDirection.text = "Dirección: " + (position!.valueForKey("direction") as! String)
                infoCity.text = "Ciudad: " + (position!.valueForKey("city") as! String)
                infoCountry.text = "País: " + (position!.valueForKey("country") as! String)
                
                
                let formater = NSDateFormatter()
                formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let myDate = "Fecha: " + formater.stringFromDate(position!.valueForKey("date") as! NSDate)
                infoDate.text = myDate
                self.locationManager.startUpdatingLocation()
                
                }
                
            } catch let error as NSError {
                print("No se pudo encontrar nada \(error), \(error.userInfo)")
            }
            
            
        }
        
        self.infoDirection.numberOfLines = 3
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.showsUserLocation = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: -Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let point = MKPointAnnotation()
        
        point.coordinate.latitude = position!.valueForKey("latitude") as! CLLocationDegrees
        point.coordinate.longitude = position!.valueForKey("longitude") as! CLLocationDegrees
 
        let center = CLLocationCoordinate2D(latitude: position!.valueForKey("latitude") as! CLLocationDegrees, longitude: position!.valueForKey("longitude") as! CLLocationDegrees)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.addAnnotation(point)
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
 
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    
    // MARK: - Navigation
    
    @IBAction func back(sender: UIBarButtonItem) {
        infoDirection.text = "Dirección: "
        infoCity.text = "Ciudad: "
        infoCountry.text = "País: "
        infoDate.text = "Fecha: "
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    
    }
    

}
