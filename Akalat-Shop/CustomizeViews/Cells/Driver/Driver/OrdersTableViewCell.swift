//
//  OrdersTableViewCell.swift
//  Akalat Driver
//
//  Created by Macbook on 09/07/2021.
//

import UIKit
import Kingfisher

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var customerAva: RoundedImageView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: TheDriverOrderDetails) {
        
        customerName.text    = (order.customer.name ?? "Customer")
        restaurantName.text  = order.restaurant.name
        customerAddress.text = order.address
            
        if let url = URL(string: order.customer.avatar ?? "") {
                let placeholder = UIImage(named: "contact-bg")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                customerAva.kf.indicatorType = .activity
            customerAva.kf.setImage(with: url,placeholder: placeholder,options: options)
            }
        }
}
