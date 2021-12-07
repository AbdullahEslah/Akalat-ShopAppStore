//
//  DriverMenuVC.swift
//  Akalat Driver
//
//  Created by Macbook on 09/07/2021.
//

import UIKit
import Kingfisher
import JGProgressHUD
import GoogleSignIn
import FBSDKLoginKit

class DriverMenuVC: UITableViewController {

    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var appleIdNameLabel: UILabel!
    @IBOutlet weak var changeLangLabel: UILabel!
    @IBOutlet weak var privacyPolicyButtonLabel: UIButton!
    @IBOutlet weak var termsButtonLabel: UIButton!
    
    let hud = JGProgressHUD(style: .dark)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Usage Of Localized Data
        let changeLangLbl = NSLocalizedString("changeLangKey", comment: "")
        self.changeLangLabel.text = changeLangLbl
        self.changeLangLabel.textAlignment = .natural
        
        let localizedPrivacy = NSLocalizedString("Privacy Policy", comment: "")
        self.privacyPolicyButtonLabel.setTitle(localizedPrivacy, for: .normal)
        
        let localizedTerm = NSLocalizedString("Term Of Use", comment: "")
        self.privacyPolicyButtonLabel.setTitle(localizedTerm, for: .normal)
        
        tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor(named: "DarkColor")
        getUserData()
    }
    
    func getUserData() {
        
        
        nameLabel.text = User.currentUser.name?.capitalized ?? ""
        
        if Constants.appleUserId != nil {
        appleIdNameLabel.numberOfLines = 0
        self.appleIdNameLabel.text = "\(Constants.appleIdFirstName ?? "Welcome") \(Constants.appleIdLastName ?? "To Akalat!")"
        } else {
            self.appleIdNameLabel.text = ""
        }
        
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        avaImage.layer.borderWidth = 1.0
        avaImage.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        
        //set placeholder
        let placeholder = UIImage(named: "d2baf949-2f8c-47ad-9985-82e2d2105d04-2")
        let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
        
        if AccessToken.current != nil {
            
            FBManager.getFBUserData(completion: {
                
                let pictureUrl = URL(string: User.currentUser.pictureURL ?? "" )
                self.avaImage.kf.setImage(with: pictureUrl,placeholder: placeholder,options: options)
            })
        }
            
        if GIDSignIn.sharedInstance.currentUser?.authentication.accessToken != nil {
        
        //For fetching google Image
            avaImage.kf.setImage(with: User.currentUser.imageURL,placeholder: placeholder,options: options)
        }
        if Constants.appleUserId != nil {
            avaImage.image = UIImage(named: "LogoWithoutName")
        }
        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "DriverLogout" {
            
            hud.textLabel.text = "Loading..."
            hud.show(in: self.view)
            
            NetworkManager.logout(completion: { error in
                
                if error == nil {
                    
                    self.hud.dismiss()
                    
                    //logourt From Facebook
                    FBManager.shared.logOut()
                    
                    //logoutFrom Google
                    GIDSignIn.sharedInstance.signOut()
                    
                    //clear our UserData
                    User.currentUser.resetInfo()
                    
                    
                    self.appleIdNameLabel.text = ""
                    
                    
                    UserDefaults.standard.removeObject(forKey: "appleUserId")
                    
                    UserDefaults.standard.removeObject(forKey: "appleIdentityToken")
                    
                    UserDefaults.standard.removeObject(forKey: "CheckDriverView")
                    
                    
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
    
    @IBAction func changeLanguageButtonTapped(_ sender: Any) {
        
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
        rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        
        
        if AppLocalization.currentAppleLanguage() == "en" {
            UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            }) { (finished) -> Void in
                AppLocalization.setAppleLAnguageTo(lang: "ar")
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                // Refresh The View To Reload The View
                let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                let orderVC = storyboard.instantiateViewController(identifier: "SWRevealViewController")
                appDelegate.window!.rootViewController = orderVC
            }
            
        } else {
            UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            }) { (finished) -> Void in
            AppLocalization.setAppleLAnguageTo(lang: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
                // Refresh The View To Reload The View
                let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                let orderVC = storyboard.instantiateViewController(identifier: "SWRevealViewController")
                appDelegate.window!.rootViewController = orderVC
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
