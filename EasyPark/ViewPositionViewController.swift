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
    
    var position: Position?
    
    let locationManager = CLLocationManager()
    
    let longitude: CLLocationDegrees = 0.0
    let latitude: CLLocationDegrees = 0.0
    var backHistory: Bool = true
    
    // MARK: - Pruebas
    //var secondView: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let position = position {
            
            backHistory = true
            
            infoDirection.text = "Dirección: " + position.direction!
            infoCity.text = "Ciudad: " + position.city!
            infoCountry.text = "País: " + position.country!
            
            
            let formater = NSDateFormatter()
            formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myDate = "Fecha: " + formater.stringFromDate(position.date)
            infoDate.text = myDate
            self.locationManager.startUpdatingLocation()
            
            //secondView = self.storyboard?.instantiateViewControllerWithIdentifier("historyView") as HistoryTableViewController
       
        }else{
            
            backHistory = false
            
            let viewLastPosition = PositionAction.viewLastPosition()
                if(!viewLastPosition.bool){
                    
                    infoDirection.text = "Dirección: "
                    infoCity.text = "Ciudad: "
                    infoCountry.text = "País: "
                    infoDate.text = "Fecha: "
                    
                    
                }else{
                
                position = viewLastPosition.position
                
                infoDirection.text = "Dirección: " + position!.direction!
                infoCity.text = "Ciudad: " + position!.city!
                infoCountry.text = "País: " + position!.country!
                
                
                let formater = NSDateFormatter()
                formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let myDate = "Fecha: " + formater.stringFromDate(position!.date)
                infoDate.text = myDate
                self.locationManager.startUpdatingLocation()
                
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
        
        point.coordinate.latitude = position!.latitude 
        point.coordinate.longitude = position!.longitude
 
        let center = CLLocationCoordinate2D(latitude: position!.latitude , longitude: position!.longitude)
        
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
        
        if(!backHistory){
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            navigationController?.popViewControllerAnimated(true)
        }
    }

    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    
    }
    

}
