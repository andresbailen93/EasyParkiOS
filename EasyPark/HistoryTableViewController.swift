//
//  HistoryTableViewController.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {

    // MARK: Properties
    
    //
    var positions = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        //loadSamplePositions()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Position")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            positions = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("No se pudo encontrar nada \(error), \(error.userInfo)")
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return positions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "HistoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        let position = positions[indexPath.row]
        
        
        cell.cityLabel.text = "Ciudad: " + (position.valueForKey("city") as! String)
        cell.directionLabel.text? = "Dirección: " + (position.valueForKey("direction") as! String)
        cell.countryLabel.text = "País: " + (position.valueForKey("country") as! String)
        
        let formater = NSDateFormatter()
        formater.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let myDate = "Fecha: " + formater.stringFromDate(position.valueForKey("date") as! NSDate)
        cell.dateLabel.text = myDate

        return cell
    }
    
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            managedContext.deleteObject(positions[indexPath.row])
            positions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            do{
              try managedContext.save()
            }catch let error as NSError {
                print("No se pudo borrar \(error), \(error.userInfo)")
            }


        }

    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    func loadSamplePositions() {
        let date = NSDate()
        let meal1 = Position(latitude: 36.7145137, longitude: -4.4791725, date: date, direction: "Calle lamargura", city: "Málaga", country: "España")

        let meal2 = Position(latitude: 36.7145, longitude: -4.4795, date: date, direction: "Calle Juanje", city: "Tánger", country: "España")
        
        
        
        positions += [meal1, meal2, meal2, meal2, meal2, meal2, meal2, meal2, meal2, meal2, meal2, meal2, meal2, meal2]
    }
*/
    
    // MARK: - Navigation
    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
 
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let positionDetailViewController = segue.destinationViewController as! ViewPositionViewController
        
        if let selectedPositionCell = sender as? HistoryTableViewCell{
            let indexPath = tableView.indexPathForCell(selectedPositionCell)!
            let selectedPosition =  positions [indexPath.row]
            
            positionDetailViewController.position = selectedPosition
        }
        
        
    }
    

}
