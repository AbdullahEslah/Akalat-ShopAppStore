//
//  ScrollViewCollectionViewCell.swift
//  Akalat-Shop
//
//  Created by Macbook on 27/10/2021.
//

import UIKit

class ScrollViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var sandwichesButton: UIButton!
    @IBOutlet weak var pizzaButton: UIButton!
    @IBOutlet weak var friedChickenButton: UIButton!
    @IBOutlet weak var grillsButton: UIButton!
    @IBOutlet weak var fishButton: UIButton!
    @IBOutlet weak var dessertsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sandwichesButton.layer.cornerRadius = sandwichesButton.frame.width / 2
        sandwichesButton.clipsToBounds = true
        
        pizzaButton.layer.cornerRadius = sandwichesButton.frame.width / 2
        pizzaButton.clipsToBounds = true
        
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
