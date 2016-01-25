//
//  HistoryTableViewCell.swift
//  EasyPark
//
//  Created by INFTEL 13 on 22/1/16.
//  Copyright © 2016 INFTEL 13. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
