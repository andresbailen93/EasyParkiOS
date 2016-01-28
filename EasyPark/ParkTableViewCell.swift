//
//  ParkTableViewCell.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var floorText: UITextField!
    @IBOutlet weak var sectionText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        floorText.enabled = false
        sectionText.enabled = false
        numberText.enabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
