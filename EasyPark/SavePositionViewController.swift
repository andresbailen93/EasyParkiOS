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
    @IBOutlet weak var savePositionButton: UIBarButtonItem!
    @IBOutlet weak var infoCountry: UILabel!
 
    //let position: Position = nil
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var date: NSDate?
    var direction: String?
    var city: String?
    var country: String?
    var positionSave: Position?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoDirection.numberOfLines = 3
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        self.savePositionButton.enabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        infoDirection.text = "Dirección: "
        infoCity.text = "Ciudad: "
        infoCountry.text = "País: "
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        
        let geoCoder = CLGeocoder()
        let locationAddress = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(locationAddress, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
                        
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


            self.locationManager.stopUpdatingLocation()
            
            self.savePositionButton.enabled = true

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

    // MARK: - Action

    @IBAction func savePosition(sender: UIBarButtonItem) {
        
        if PositionAction.savePosition(self.direction!, city: self.city!, country: self.country!, latitude: self.latitude, longitude: self.longitude, date: self.date!) {
                  showAlertSavePosition()
            
        }
    }
}
