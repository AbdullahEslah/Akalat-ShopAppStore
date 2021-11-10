//
//  MealsCollectionViewCell.swift
//  EgyStore
//
//  Created by Macbook on 6/8/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit
import Kingfisher

class MealsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealDesc: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    @IBOutlet weak var mealImage: RoundedImage!
    @IBOutlet weak var roundedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    
    func configureCell(meal: MealsResult) {
        mealName.text = meal.name
        mealDesc.text = meal.short_description
        mealPrice.text = "\(meal.price)"
        
        if let url = URL(string: meal.image) {
            let placeholder = UIImage(named: "contact-bg")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            mealImage.kf.indicatorType = .activity
            mealImage.kf.setImage(with: url,placeholder: placeholder,options: options)
        }
    }

}
