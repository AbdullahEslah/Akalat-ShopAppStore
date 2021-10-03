//
//  LogoVC.swift
//  EgyStore
//
//  Created by Macbook on 11/8/20.
//  Copyright © 2020 Abdallah Eslah. All rights reserved.
//

import UIKit
import SwiftyGif
class LogoVC: UIViewController {
    
    let logoAnimationView = LogoAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
    }
    

    override func viewDidAppear(_ animated: Bool) {
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }

}

extension LogoVC: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}
