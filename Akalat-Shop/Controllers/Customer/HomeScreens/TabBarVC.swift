//
//  TabBarVC.swift
//  Akalat Shop
//
//  Created by Macbook on 09/08/2021.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of text under icon in tabbar controller
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], for: UIControl.State())
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor :UIColor(named: "DarkColor")!], for: .selected)
    }
    

   

}
