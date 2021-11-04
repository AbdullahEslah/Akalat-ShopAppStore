//
//  Constants.swift
//  Akalat Shop
//
//  Created by Macbook on 06/07/2021.
//

import Foundation
import Lottie

class Constants {
    
    static var region  = UserDefaults.standard.value(forKey: "region") as? String
    static var address = UserDefaults.standard.value(forKey: "address") as? String
    static var phone   = UserDefaults.standard.value(forKey: "phone") as? String
    
    //Categories
    static var Sandwiches = "Sandwiches"
    
    //LOADING USING LOTTIE
    let animationView = AnimationView(animation: Animation.named("lf30_editor_reir1nit"))
    
}
