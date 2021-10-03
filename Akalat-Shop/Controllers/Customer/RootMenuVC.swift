//
//  RootMenuVC.swift
//  EgyStore
//
//  Created by Macbook on 11/7/20.
//  Copyright © 2020 Abdallah Eslah. All rights reserved.
//

//import UIKit
//import Foundation
//import SwiftyGif
//
//final class RootMenuVC: AKSideMenu, AKSideMenuDelegate {
//    
//    let logoAnimationView = LogoAnimationView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.addSubview(logoAnimationView)
//        logoAnimationView.pinEdgesToSuperView()
//        logoAnimationView.logoGifImageView.delegate = self
//        
//        
//    }
//
//     override func viewDidAppear(_ animated: Bool) {
//            logoAnimationView.logoGifImageView.startAnimatingGif()
//            
//        }
//
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.menuPreferredStatusBarStyle = .lightContent
//        self.contentViewShadowColor = .black
//        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
//        self.contentViewShadowOpacity = 0.6
//        self.contentViewShadowRadius = 12
//        self.contentViewShadowEnabled = true
//
//        self.backgroundImage = UIImage(named: "Stars")
//        self.delegate = self
//
//        if let storyboard = self.storyboard {
//            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
//            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
//        }
//    }
//    
//    
//
//    // MARK: - <AKSideMenuDelegate>
//
//    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
//        debugPrint("willShowMenuViewController")
//    }
//
//    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
//        debugPrint("didShowMenuViewController")
//    }
//
//    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
//        debugPrint("willHideMenuViewController")
//    }
//
//    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
//        debugPrint("didHideMenuViewController")
//    }
//   
//    
//}
//extension RootMenuVC: SwiftyGifDelegate {
//    func gifDidStop(sender: UIImageView) {
//        logoAnimationView.isHidden = true
//    }
//}
