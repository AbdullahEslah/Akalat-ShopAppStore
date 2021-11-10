//
//  TrackerTableViewCell.swift
//  EgyStore
//
//  Created by Macbook on 6/14/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit

class TrackerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealCountLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealPriceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
