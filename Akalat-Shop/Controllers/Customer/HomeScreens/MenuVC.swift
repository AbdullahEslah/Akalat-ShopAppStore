//
//  LeftVC.swift
//  EgyStore
//
//  Created by Macbook on 11/15/20.
//  Copyright © 2020 Abdallah Eslah. All rights reserved.
//

import UIKit
import JGProgressHUD
import Kingfisher
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class MenuVC: UITableViewController {

    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var appleIdNameLabel: UILabel!
    @IBOutlet weak var changeLangButton: UISwitch!
    @IBOutlet weak var changeLangLabel: UILabel!
    @IBOutlet weak var privacyPolicyButtonLabel: UIButton!
    @IBOutlet weak var termsButtonLabel: UIButton!
    
    
    let hud = JGProgressHUD(style: .dark)
    let applenameLabelPlaceholder = "Welcome Back"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let localizedPrivacy = NSLocalizedString("Privacy Policy", comment: "")
        self.privacyPolicyButtonLabel.setTitle(localizedPrivacy, for: .normal)
        
        let localizedTerm = NSLocalizedString("Term Of Use", comment: "")
        self.termsButtonLabel.setTitle(localizedTerm, for: .normal)
        view.backgroundColor = UIColor(named: "DarkColor")
        getUserData()
        tableView.tableFooterView = UIView()
        
    }
 
    func getUserData() {
        nameLabel.text = User.currentUser.name?.capitalized ?? ""

        if Constants.appleUserId != nil {
        appleIdNameLabel.numberOfLines = 0
        self.appleIdNameLabel.text = "\(Constants.appleIdFirstName ?? "Welcome") \(Constants.appleIdLastName ?? "To Akalat!")"
            avaImage.image = UIImage(named: "LogoWithoutName")
        } else {
            self.appleIdNameLabel.text = ""
            avaImage.image = UIImage(named: "LogoWithoutName")
//            self.appleIdNameLabel.text = "Welcome To Akalat Shop!"
        }
   

        //set placeholder
        let placeholder = UIImage(named: "d2baf949-2f8c-47ad-9985-82e2d2105d04-2")
        let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
        
        if AccessToken.current != nil {
            
            FBManager.getFBUserData(completion: {
                
                //Get User Data
                //for fetching Facebook image
                let facebookImage = URL(string: User.currentUser.pictureURL ?? "" )
                self.avaImage.kf.setImage(with: facebookImage,placeholder: placeholder,options: options)
                
            })
        }
        
        if GIDSignIn.sharedInstance.currentUser?.authentication.accessToken != nil {
        
        //For fetching google Image
//        let googleImage = URL(string: User.currentUser.pictureURL ?? "" )
            avaImage.kf.setImage(with: User.currentUser.imageURL,placeholder: placeholder,options: options)
        }
        
        
        self.avaImage.layer.cornerRadius = self.avaImage.frame.width / 2
        self.avaImage.clipsToBounds = true
        self.avaImage.layer.borderWidth = 1.0
        self.avaImage.layer.borderColor = UIColor(named: "MainColor")?.cgColor

        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CustomerLogout" {
            
            hud.textLabel.text = "Loading..."
            hud.show(in: self.view)
            
            // For the purpose of this demo app, delete the user identifier that was previously stored in the keychain.
            
//            nameLabel.text = KeychainItem.currentUserIdentifier
            NetworkManager.logout(completion: { error in
                
                if error == nil {
                    
                    self.hud.dismiss()
                    //logourt From Facebook
                    FBManager.shared.logOut()
                    
                    GIDSignIn.sharedInstance.signOut()
                    
                    self.appleIdNameLabel.text = ""
                    
                    
                    UserDefaults.standard.removeObject(forKey: "appleUserId")
                    
                    UserDefaults.standard.removeObject(forKey: "appleIdentityToken")
                    
                    UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
 

                    //clear our UserData
                    User.currentUser.resetInfo()
//                    AppleUser.currentUser.resetInfo()
                    
                    self.appleIdNameLabel.text = ""
                    
                    
                    //refresh the view to remove continue with your email from LoginVC to force go back to it
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginVC
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = vc
                    
                }
                self.hud.dismiss()
            })
            return false
        }
        return true
    }
    
    
    @IBAction func changeLangButtonTapped(_ sender: Any) {
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        
        if AppLocalization.currentAppleLanguage() == "en" {
            UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            }) { (finished) -> Void in
                AppLocalization.setAppleLAnguageTo(lang: "ar")
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                // Refresh The View To Reload The View
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let TabBarVC = storyboard.instantiateViewController(identifier: "TabBarVC")
                appDelegate.window!.rootViewController = TabBarVC
            }
            
        } else {
            UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            }) { (finished) -> Void in
                AppLocalization.setAppleLAnguageTo(lang: "en")
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                // Refresh The View To Reload The View
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let TabBarVC = storyboard.instantiateViewController(identifier: "TabBarVC")
                appDelegate.window!.rootViewController = TabBarVC
            }
        }

    }
    
    @IBAction func termsOfUserDidTapped(_ sender: Any) {
        
        guard let settingsUrl = URL(string:"https://sites.google.com/view/akalatshoptermsof-use/home") else {
            return
        }
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func privacyPolicyDidTapped(_ sender: Any) {
        guard let settingsUrl = URL(string:"https://sites.google.com/view/akalatshopprivacypolicy/home") else {
            return
        }
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
}

