//
//  RestaurantsSlideShowCell.swift
//  Akalat-Shop
//
//  Created by Macbook on 16/11/2021.
//

import UIKit
import Kingfisher

class SliderCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var restaurantImage: RoundedImageView!
    
    @IBOutlet var restaurantName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

   
    func configureCell(restaurant: RestaurntsResult) {
        restaurantName.numberOfLines = 0
        restaurantName.text = restaurant.name
        restaurantName.font = UIFont(name: "Iceland", size: 30)
       
        
        if let url = URL(string: restaurant.logo) {
            let placeholder = UIImage(named: "contact-bg")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            restaurantImage.kf.indicatorType = .activity
            restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
        }
    }
    
  
}
