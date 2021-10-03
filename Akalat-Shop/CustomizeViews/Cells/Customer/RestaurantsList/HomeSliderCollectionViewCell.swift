//
//  HomeSliderCollectionViewCell.swift
//  Akalat Shop
//
//  Created by Macbook on 7/1/21.
//

import UIKit
import Kingfisher

class HomeSliderCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var restaurantsImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(restaurant: RestaurntsResult) {
        restaurantNameLabel.text = restaurant.name
        
        if let url = URL(string: restaurant.logo) {
            let placeholder = UIImage(named: "contact-bg")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            restaurantsImage.kf.indicatorType = .activity
            restaurantsImage.kf.setImage(with: url,placeholder: placeholder,options: options)
        }
    }

}
