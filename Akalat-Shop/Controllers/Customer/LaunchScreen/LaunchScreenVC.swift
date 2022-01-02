//
//  LaunchScreenVC.swift
//  Akalat-Shop
//
//  Created by Macbook on 29/10/2021.
//

import UIKit

class LaunchScreenVC: UIViewController {
    
    @IBOutlet weak var animatedImgae: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Animation setup
      
        animatedImgae.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: Fire initial animations
        animateLogo()
    }
    
    func animateLogo() {
        
        UIView.animate(withDuration: 1.5, delay: 0.75, options: [.repeat, .autoreverse], animations: {
            self.animatedImgae.alpha = 1
            self.animatedImgae.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            DispatchQueue.main.asyncAfter(deadline: .now()+6, execute: {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(identifier: "LoginVC")
                loginVC.modalTransitionStyle = .crossDissolve
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            })
        }
            , completion: nil)
    }
}
