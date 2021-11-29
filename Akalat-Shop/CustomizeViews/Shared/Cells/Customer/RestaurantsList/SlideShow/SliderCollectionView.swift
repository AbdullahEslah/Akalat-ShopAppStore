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
    
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet var findoutLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

   
    func configureCell(restaurant: RestaurntsResult) {
        restaurantName.numberOfLines = 0
        restaurantName.text = restaurant.name
        findoutLabel.font = UIFont(name: "Iceland", size: 30)
        findoutLabel.text = "Tap To Find Out!"
        
        if let url = URL(string: restaurant.logo) {
            let placeholder = UIImage(named: "contact-bg")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            restaurantImage.kf.indicatorType = .activity
            restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
        }
    }
    
  
}
