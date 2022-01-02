//
//  RestaurantsHeaderView.swift
//  Akalat-Shop
//
//  Created by Macbook on 26/10/2021.
//

import UIKit

class RestaurantsHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var sandwichHeaderButton: UIButton!
    @IBOutlet weak var pizzaHeaderButton: UIButton!
    @IBOutlet weak var friedChickenButton: UIButton!
    @IBOutlet weak var grillsButton: UIButton!
    @IBOutlet weak var fishButton: UIButton!
    @IBOutlet weak var dessertsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sandwichHeaderButton.layer.cornerRadius = sandwichHeaderButton.frame.width / 2
        sandwichHeaderButton.clipsToBounds = true
        
        pizzaHeaderButton.layer.cornerRadius = pizzaHeaderButton.frame.width / 2
        pizzaHeaderButton.clipsToBounds = true
        
        friedChickenButton.layer.cornerRadius = friedChickenButton.frame.width / 2
        friedChickenButton.clipsToBounds = true
        
        grillsButton.layer.cornerRadius = grillsButton.frame.width / 2
        grillsButton.clipsToBounds = true
        
        fishButton.layer.cornerRadius = fishButton.frame.width / 2
        fishButton.clipsToBounds = true
        
        dessertsButton.layer.cornerRadius = dessertsButton.frame.width / 2
        dessertsButton.clipsToBounds = true
    }
    
}
