//
//  LatestOrdersTableViewCell.swift
//  Akalat-Shop
//
//  Created by Macbook on 18/10/2021.
//

import UIKit

class LatestOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealQuantity: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: LatestDriverOrderDetails) {
        
        mealName.text     = order.meal.name
        mealPrice.text    = "\(order.sub_total)"
        mealQuantity.text = "\(order.quantity)"

    }
    
}
