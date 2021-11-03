//
//  CustomRestaurantLayoutCollectionViewCell.swift
//  Akalat Shop
//
//  Created by Macbook on 14/07/2021.
//

import UIKit


class CustomRestaurantLayoutCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var restaurantImage: RoundedImageView!
    
   
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantName.numberOfLines = 0
    }

    

}
