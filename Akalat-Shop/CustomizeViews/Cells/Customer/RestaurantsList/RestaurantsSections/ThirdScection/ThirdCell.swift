//
//  ThirdCell.swift
//  Akalat-Shop
//
//  Created by Macbook on 01/11/2021.
//

import UIKit

class ThirdCell: UICollectionViewCell {
    
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImageView: RoundedImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        sectionName.text = "Best For Pizza"
//        sectionName.textAlignment = .natural
    }

}
