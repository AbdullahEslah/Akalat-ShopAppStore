//
//  RestaurantsTableViewCell.swift
//  EgyStore
//
//  Created by Macbook on 6/8/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit
import Kingfisher


class RestaurantsTableViewCell: UITableViewCell {
    
   
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    
    private var task: URLSessionDataTask?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       
    }
    
    func configureCell(restaurant: RestaurntsResult) {
        
            restaurantName.text = restaurant.name
            restaurantAddress.text = restaurant.address
            
            if let url = URL(string: restaurant.logo) {
                let placeholder = UIImage(named: "contact-bg")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                restaurantImage.kf.indicatorType = .activity
                restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
            }
        }
    
}
