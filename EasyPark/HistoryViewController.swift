//
//  HistoryViewController.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    @IBAction func back(sender: UIBarButtonItem) {
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
