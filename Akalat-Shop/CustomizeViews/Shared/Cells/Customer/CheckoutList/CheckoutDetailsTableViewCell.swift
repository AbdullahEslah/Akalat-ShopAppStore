//
//  CheckoutDetailsTableViewCell.swift
//  EgyStore
//
//  Created by Macbook on 6/12/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit

class CheckoutDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealPrice: UILabel!
    @IBOutlet weak var mealCount: UILabel!
    @IBOutlet weak var mealName: UILabel!
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
       //mealCount.layer.masksToBounds = true
        mealCount.clipsToBounds = true
        mealCount.layer.cornerRadius = mealCount.frame.width / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mealCount.layer.borderColor = UIColor.label.cgColor
        mealCount.layer.borderWidth = 1.0
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Configure the view for the selected state
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
