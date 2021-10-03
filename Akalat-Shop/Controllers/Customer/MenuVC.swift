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
    
    
    let hud = JGProgressHUD(style: .dark)
    let applenameLabelPlaceholder = "Welcome Back"
//    var peopleDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "DarkColor")
        getUserData()
    }
    
//    func getPeopleList() {
//        let urlString = ("https://www.googleapis.com/plus/v1/people/me/people/visible?access_token=\(GIDSignIn.sharedInstance().currentUser.authentication.accessToken)")
//        let url = NSURL(string: urlString)
//
//        performGetRequest(url, completion: { (data, HTTPStatusCode, error) -> Void in
//            if HTTPStatusCode == 200 && error == nil {
//                let resultsDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! Dictionary<NSObject, AnyObject>
//
//                // Get the array with people data dictionaries.
//                let peopleArray = resultsDictionary["items"] as! Array<Dictionary<NSObject, AnyObject>>
//
//                // For each item get the display name and download the picture.
//                // Store these values in a new dictionary, and then in the peopleDataArray array.
//                for item in peopleArray {
//                    var dictionary = Dictionary<NSObject, AnyObject>()
//                    dictionary["displayName"] = item["displayName"] as! String
//
//                    let imageURLString = (item["image"] as! Dictionary<NSObject, AnyObject>)["url"] as! String
//                    dictionary["imageData"] = NSData(contentsOfURL: NSURL(string: imageURLString)!)
//
//                    self.peopleDataArray.append(dictionary)
//                }
//
//                // Reload the tableview data.
//                self.tblContent.reloadData()
//            }
//            else {
//                println(HTTPStatusCode)
//                println(error)
//            }
//        })
//    }
    
    func getUserData() {
        nameLabel.text = User.currentUser.name ?? ""

        appleIdNameLabel.numberOfLines = 0
        self.appleIdNameLabel.text = "\(Constants.appleIdFirstName ?? "Welcome") \(Constants.appleIdLastName ?? "To Akalat!")"
   
//        }
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
        if GIDSignIn.sharedInstance()?.currentUser?.authentication.accessToken != nil {
        
        //For fetching google Image
//        let googleImage = URL(string: User.currentUser.pictureURL ?? "" )
            avaImage.kf.setImage(with: User.currentUser.imageURL,placeholder: placeholder,options: options)
        }
        
        if Constants.appleUserId != nil {
//            LogoWithoutName
            avaImage.image = UIImage(named: "LogoWithoutName")
            
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
                    
                    GIDSignIn.sharedInstance()?.signOut()
                    
                    self.appleIdNameLabel.text = ""
                    
                    
                    UserDefaults.standard.removeObject(forKey: "appleUserId")
                    print(UserDefaults.standard.value(forKey: "appleUserId"))
                    
                    UserDefaults.standard.removeObject(forKey: "appleIdentityToken")
                    print(UserDefaults.standard.value(forKey: "appleIdentityToken"))
                    
                    UserDefaults.standard.removeObject(forKey: "appleIdFirstName")
                    print(UserDefaults.standard.value(forKey: "appleIdFirstName"))
                    
                    UserDefaults.standard.removeObject(forKey: "appleIdLastName")
                    print( UserDefaults.standard.value(forKey: "appleIdLastName"))
                    
                    UserDefaults.standard.removeObject(forKey: "appleIdEmail")
                    print(UserDefaults.standard.value(forKey: "appleIdEmail"))
                    
                    UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
                    print(UserDefaults.standard.value(forKey: "CustomerOrDriver") )

                    //clear our UserData
                    User.currentUser.resetInfo()
//                    AppleUser.currentUser.resetInfo()
                    
//                    self.appleIdNameLabel.text = ""
                    
                    
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
