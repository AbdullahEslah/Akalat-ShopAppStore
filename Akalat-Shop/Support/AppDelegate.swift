//
//  AppDelegate.swift
//  Akalat Shop
//
//  Created by Macbook on 6/16/21.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import IQKeyboardManagerSwift



// global variable refered to appDelegate to be able to call it from any class / file.swift
let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

// colors
let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let colorLightGreen = UIColor(red: 30/255, green: 244/255, blue: 125/255, alpha: 1)

// sizes
let fontSize12 = UIScreen.main.bounds.width / 31

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

//    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    //variable errorViewIsShowing for checking errorView is currently showing or not
    var infoViewIsShowing = false

    var window: UIWindow?
    
    //image to be animated for firstScreen
    let backgroundImg = UIImageView()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if Constants.region != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LaunchScreenVC")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = loginVC
        }
        
        AppLocalizationHelper.DoTheMagic()
        
        IQKeyboardManager.shared.enable = true
        
        //creating imageview to store background image -> "any image wanted to be animated"
        backgroundImg.frame = CGRect(x: 0, y: 0, width: self.window!.bounds.height * 1.688, height: self.window!.bounds.height )
        backgroundImg.image = UIImage(named:"Background")
        self.window!.addSubview(backgroundImg)
        
        
        moveLeft()
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "WhiteColor")
        UINavigationBar.appearance().tintColor = UIColor(named: "MainColor")
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(named: "DarkColor")!]
        
        //FB Sign-in Handling State
         ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        //Google Sign-in  State
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
                
                if Constants.region != nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let launchScreenVC = storyboard.instantiateViewController(identifier: "LaunchScreenVC")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = launchScreenVC
                } else {
                    let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
                    let onBoarding = storyboard.instantiateViewController(identifier: "OnBoardingVC")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = onBoarding
                }
               
            } else {
              // Show the app's signed-in state.
                if UserDefaults.standard.value(forKey: "CheckDriverView") == nil {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let launchScreen = storyboard.instantiateViewController(identifier: "LaunchScreenVC")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = launchScreen
                    
                }else {
                    let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                    let driverLaunchScreen = storyboard.instantiateViewController(identifier: "LaunchScreenDriverVC")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = driverLaunchScreen
                }
            }
        }
        return true
    }
    
    
    

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }
 
         ApplicationDelegate.shared.application(
                app,
                open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        return false
        }

        
    
    // error view on top if it's not right email & password
    // infoView view on top
    @objc func infoView(message:String, color:UIColor) {
        
        // if infoView is not showing ...
        if infoViewIsShowing == false {
            
            // cast as infoView is currently showing
            infoViewIsShowing = true
            
            // infoView - red background
            let infoView_Height = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Height
            
            let infoView = UIView(frame: CGRect(x: 0, y: infoView_Y, width: self.window!.bounds.width, height: infoView_Height))
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            // infoView - label to show info text
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Height = infoView.bounds.height + height / 2
            
            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Height
            infoLabel.numberOfLines = 0
            
            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
            infoLabel.textColor = .white
            infoLabel.textAlignment = .center
            
            infoView.addSubview(infoLabel)
            
            
            // animate info view
            UIView.animate(withDuration: 0.2, animations: {
                
                // move down infoView
                infoView.frame.origin.y = 0
                
                // if animation did finish
                }, completion: { (finished:Bool) in
                    
                    // if it is true
                    if finished {
                        
                        UIView.animate(withDuration: 0.1, delay: 5, options: .curveLinear, animations: {
                        
                            // move up infoView
                            infoView.frame.origin.y = infoView_Y
                        
                        // if finished all animations
                        }, completion: { (finished:Bool) in
                          
                            if finished {
                                infoView.removeFromSuperview()
                                infoLabel.removeFromSuperview()
                                self.infoViewIsShowing = false
                            }
                            
                        })
                        
                    }
                    
            })
            
            
        }
        
    }
    
    
<<<<<<< HEAD
=======
    
    
    
    
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    //functions to animte backrounds towards to directions
    func moveLeft(){
        UIView.animate(withDuration: 45, animations: {
            //change horizontal origin
            self.backgroundImg.frame.origin.x = -self.backgroundImg.bounds.width + self.window!.bounds.width
        }) {(finished:Bool) in

            //if animation finished , excute func moveRight()

            if finished {
                //move right
                self.moveRight()
            }
        }
    }
    
    func moveRight(){
        UIView.animate(withDuration: 45, animations: {
            self.backgroundImg.frame.origin.x = 0
        }) {(finished:Bool) in
                if finished {
                    //move right
                    self.moveLeft()
                }
            }
        }

    func applicationWillResignActive(_ application: UIApplication) {
              // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions
              //(such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background
              // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method
          }

          func applicationDidEnterBackground(_ application: UIApplication) {
              // Use this method to release shared resources, save user data, invalidate timers, and store enough application state
              //information to restore your application
              //to its current state in case it is terminated later.
              // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
          }

          func applicationWillEnterForeground(_ application: UIApplication) {
              // Called as part of the transition from the background to the active state; here you can undo many of the
              //changes made on entering the background.
          }

          func applicationDidBecomeActive(_ application: UIApplication) {
              // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was
              //previously in the background, optionally refresh the user interface.
          }

          func applicationWillTerminate(_ application: UIApplication) {
              // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
              // Saves changes in the application's managed object context before the application terminates.
          }
        
        
    }
