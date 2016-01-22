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


class SavePositionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoDirection: UILabel!
    @IBOutlet weak var infoCity: UILabel!
    @IBOutlet weak var infoCountry: UILabel!
 
    
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
            }
            if let letCity = placeMark.addressDictionary!["City"] as? String{
                if let letZip = placeMark.addressDictionary!["ZIP"] as? String{
                    self.infoCity.text = "Ciudad: " + letCity+", "+letZip
                }
            }
            if let letCountry = placeMark.addressDictionary!["Country"] as? String{
                self.infoCountry.text = "País: " + letCountry
            }
            
            
            
            
            
        })
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    

    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
