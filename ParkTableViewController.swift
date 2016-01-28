//
//  ParkTableViewController.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController {

    // MARK: Properties

    var parkZones = [ParkZone]()
    var parkZoneFree: ParkZoneFree?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parkZoneFree = parkZoneFree {
            self.parkZoneFree = parkZoneFree
            ParkZoneAction.loadCC(self, nameCC: parkZoneFree.nombre!)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parkZones.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ParkTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ParkTableViewCell

        
        let parkZone = parkZones[indexPath.row]
        
        cell.floorLabel.text = parkZone.floor
        cell.sectionLabel.text = parkZone.section
        cell.numberLabel.text = parkZone.number
        cell.photo.image = parkZone.photo

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let parkZone = parkZones[indexPath.row]
            ParkZoneAction.putBooking(self,parkZone: parkZone)
        
    }
    
    // MARK: -Alert
 
   /// Show an alert with an "Okay" button.
    func showAlertReserved(text: String) {
        var alert: UIAlertActionStyle
        let title = NSLocalizedString("Reservar plaza", comment: "")
        let message = NSLocalizedString(text, comment: "")
        let acceptButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var cancelAction: UIAlertAction
        // Create the action.
        if text.containsString("ERROR"){
            alert = .Destructive
            
            cancelAction = UIAlertAction(title: acceptButtonTitle, style: alert) { action in
               ParkZoneAction.loadCC(self,nameCC: (self.parkZoneFree?.nombre)!)
            }
           
            
        }else{
            alert = .Default
            cancelAction = UIAlertAction(title: acceptButtonTitle, style: alert) { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
   
    // MARK: - Navigation

    @IBAction func back(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }

}
