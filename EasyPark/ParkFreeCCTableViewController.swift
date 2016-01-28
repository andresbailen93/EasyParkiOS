//
//  ParkFreeCCTableViewController.swift
//  EasyPark
//
//  Created by INFTEL 13 on 27/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit

class ParkFreeCCTableViewController: UITableViewController {
    
    var parkZonesFree = [ParkZoneFree]()
    
    var ci = ParkZoneFree(numberFree: "", image: "corte", nombre: "ci")
    
    var ca = ParkZoneFree (numberFree: "", image: "carrefour", nombre: "ca")

    override func viewDidLoad() {
        super.viewDidLoad()
        ParkZoneAction.getUserParkZone(self)
        loadPositions()
        
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
        return parkZonesFree.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ParkFreeCCTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ParkFreeCCTableViewCell
        
        let parkZoneFree = parkZonesFree[indexPath.row]
        
        
        
        cell.numberFreeLabel.text = parkZoneFree.numberFree
        cell.imageCC.image = parkZoneFree.image
        
        return cell
    }

    func loadPositions() {
       
        self.parkZonesFree += [ci,ca]
        
        ParkZoneAction.readCountCarrefour(self)
        ParkZoneAction.readCountCorteIngles(self)
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let freeParkViewController = segue.destinationViewController as! ParkTableViewController
        
        if let selectedPositionCell = sender as? ParkFreeCCTableViewCell{
            let indexPath = tableView.indexPathForCell(selectedPositionCell)!
            let selectedPosition =  parkZonesFree [indexPath.row]
            
            freeParkViewController.parkZoneFree = selectedPosition
        }
        
        
    }
    
    /// Show an alert with an "Okay" and "Cancel" button.
    func showAlertReserved(item: AnyObject) {
        
        let nameC = item["centrocomercial"] as! String
        let floor = item["planta"] as! String
        let sect = item["seccion"] as! String
        let number = item["numero"] as! String
        let id_parkZone = item["idPlaza"] as! Int
        var photo: String
        
        if nameC == "carrefour"{
            photo = "carrefour"
        }else{
            photo = "corte"
        }
        let parkZone = ParkZone(name: item["centrocomercial"] as! String, floor: floor, section: sect, number: number, photo: photo, id_parkZone: id_parkZone)
        
        let title = NSLocalizedString("Usted ya tiene una plaza reservada en \(nameC), planta \(floor), sección \(sect) y número \(number)", comment: "")
        let message = NSLocalizedString("¿Desea cancerla su reserva ?", comment: "")
        let cancelButtonTitle = NSLocalizedString("NO", comment: "")
        let otherButtonTitle = NSLocalizedString("SI", comment: "")
        
        let alertCotroller = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .Default) { _ in
            ParkZoneAction.putCancelBooking(parkZone)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        // Add the actions.
        alertCotroller.addAction(cancelAction)
        alertCotroller.addAction(otherAction)
        
        presentViewController(alertCotroller, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

 
    

}
