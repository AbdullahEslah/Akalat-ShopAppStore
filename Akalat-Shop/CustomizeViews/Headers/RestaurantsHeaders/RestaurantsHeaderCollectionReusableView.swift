//
//  RestaurantsHeaderCollectionReusableView.swift
//  Akalat Shop
//
//  Created by Macbook on 14/07/2021.
//

import UIKit

class RestaurantsHeaderCollectionReusableView: UICollectionReusableView {

    
    @IBOutlet weak var headerLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headerLabel.textAlignment = .natural
       
        
    }
   
}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if AppLocalization.currentAppleLanguage() == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        }
    }
}
