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
    var myRoute : MKRoute?
    
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
            
            
            /*let formater = NSDateFormatter()
            formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myDate = "Fecha: " + formater.stringFromDate(position.date)*/
            infoDate.text = PositionAction.getDateFormatted(position.date) // myDate
            self.locationManager.startUpdatingLocation()
       
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
                
                
                /*let formater = NSDateFormatter()
                formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let myDate = "Fecha: " + formater.stringFromDate(position!.date)*/
                infoDate.text = PositionAction.getDateFormatted(position!.date) // myDate
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
        let location = locations.last
        
        let point2 = MKPointAnnotation()
        point2.coordinate = CLLocationCoordinate2DMake(position!.latitude , position!.longitude)
        mapView.addAnnotation(point2)

        if !backHistory{
            let point1 = MKPointAnnotation()
            point1.coordinate = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
            mapView.delegate = self
        
            let directionsRequest = MKDirectionsRequest()
            let markPoint1 = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
            let markPoint2 = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        
            directionsRequest.source = MKMapItem(placemark: markPoint1)
            directionsRequest.destination = MKMapItem(placemark: markPoint2)
            directionsRequest.transportType = MKDirectionsTransportType.Walking

            let directions = MKDirections(request: directionsRequest)
            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
            
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
 
        let center = CLLocationCoordinate2D(latitude: position!.latitude , longitude: position!.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
 
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
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
    
}
