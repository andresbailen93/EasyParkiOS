//
//  SavePositionViewController.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class SavePositionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoDirection: UILabel!
    @IBOutlet weak var infoCity: UILabel!
    @IBOutlet weak var infoCountry: UILabel!
 
    //let position: Position = nil
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var date: NSDate?
    var direction: String?
    var city: String?
    var country: String?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoDirection.numberOfLines = 3
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        let geoCoder = CLGeocoder()
        let locationAddress = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(locationAddress, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            print(placeMark.addressDictionary)
            
            if let letDirection = placeMark.addressDictionary!["Thoroughfare"] as? String{
                self.infoDirection.text = "Dirección: "+letDirection
                self.direction = letDirection
            }else{
                self.direction = ""
            }
            if let letCity = placeMark.addressDictionary!["City"] as? String{
                if let letZip = placeMark.addressDictionary!["ZIP"] as? String{
                    self.infoCity.text = "Ciudad: " + letCity+", "+letZip
                    self.city = letCity
                }
            }else{
                self.city = ""
            }
            if let letCountry = placeMark.addressDictionary!["Country"] as? String{
                self.infoCountry.text = "País: " + letCountry
                self.country = letCountry
            }else{
                self.country = ""
            }
            
            
            self.longitude = location!.coordinate.longitude
            self.latitude = location!.coordinate.latitude
            
            let date = NSDate()
            self.date = date
            //let formater = NSDateFormatter()
            //formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
            //formater.stringFromDate(date)
            //infoDate.text = "Fecha: " + formater.stringFromDate(date)

            
            
            
            
            
        })
        
    }
    
    
    /// Show an alert with an "Okay" button.
    func showAlertSavePosition() {
        let title = NSLocalizedString("Guardar Posición", comment: "")
        let message = NSLocalizedString("Se ha guardado la posición correctamente", comment: "")
        let acceptButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: acceptButtonTitle, style: .Cancel) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    

    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        infoDirection.text = "Dirección: "
        infoCity.text = "Ciudad: "
        infoCountry.text = "País: "
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Action

    @IBAction func savePosition(sender: UIBarButtonItem) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Position", inManagedObjectContext: managedContext)
        
        let position = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        position.setValue(self.longitude, forKey: "longitude")
        position.setValue(self.latitude, forKey: "latitude")
        position.setValue(self.city, forKey: "city")
        position.setValue(self.country, forKey: "country")
        position.setValue(self.direction, forKey: "direction")
        position.setValue(self.date, forKey: "date")
        
        do {
            try managedContext.save()
            showAlertSavePosition()
            
        } catch let error as NSError {
                print("No se pudo guardar \(error), \(error.userInfo)")
        }
      

    }
}
