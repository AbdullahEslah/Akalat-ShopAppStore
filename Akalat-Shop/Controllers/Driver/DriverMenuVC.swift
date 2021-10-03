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

class DriverMenuVC: UITableViewController {

    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "DarkColor")
        getUserData()
    }
    
    func getUserData() {
        nameLabel.text = User.currentUser.name ?? ""
        
        //set placeholder
        let placeholder = UIImage(named: "d2baf949-2f8c-47ad-9985-82e2d2105d04-2")
        let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
        let pictureUrl = URL(string: User.currentUser.pictureURL ?? "" )
        avaImage.kf.setImage(with: pictureUrl,placeholder: placeholder,options: options)

        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        avaImage.layer.borderWidth = 1.0
        avaImage.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        
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
                    GIDSignIn.sharedInstance()?.signOut()
                    
                    //clear our UserData
                    User.currentUser.resetInfo()
                    
                    UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
//                    UserDefaults.standard.synchronize()
                    print(UserDefaults.standard.value(forKey: "CustomerOrDriver") ?? "")
                    //refresh the view to remove continue with your email from LoginVC to force go back to it
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginVC
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = vc
                    
                }
                self.hud.dismiss()
                print(error)
            })
            return false
        }
        return true
    }
}
