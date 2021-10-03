//
//  LogoAnimationView.swift
//  EgyStore
//
//  Created by Macbook on 11/8/20.
//  Copyright © 2020 Abdallah Eslah. All rights reserved.
//

import UIKit
import SwiftyGif

class LogoAnimationView: UIView {
    
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "01b70e161162a92685d0ebbb45acf5ba.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: 1)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoGifImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
        logoGifImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        logoGifImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
}

extension UIView {
    
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
            
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
}

