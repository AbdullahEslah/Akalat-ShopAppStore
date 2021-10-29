//
//  LoginVC.swift
//  EgyStore
//
//  Created by Macbook on 11/15/20.
//  Copyright © 2020 Abdallah Eslah. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import JGProgressHUD
import Kingfisher
import Lottie
import Network

class LoginVC: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var internetConnectionLabel: UILabel!
    
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var viewForMyButton: UIView!
    @IBOutlet weak var showAuthButton: UIButton!
    @IBOutlet weak var topLineOfAuthHolderView: RoundedShadowView!
    //Objects
    @IBOutlet weak var authHolderView: UIView!
   
    @IBOutlet weak var deliverOrdersButton: UIButton!
    
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
   
    @IBOutlet weak var authHolderViewHeight: NSLayoutConstraint!
   
    
    var userID :String?
    //Handle Appearnace Of AuthView
    var defaultAuthHolderViewHeight : CGFloat = 0.0
    
    //Anim duration - change to something like 1.0 to see the effect in "slo-motion"
    let animDuration                = 1.0
    
    let hud            = JGProgressHUD(style: .dark)
    var userType       : String  = NetworkManager.Auth.userTypeCustomer
    var driverUserType : String  = NetworkManager.Auth.userTypeDriver
    let monitor        = NWPathMonitor()
    
    let animationView = AnimationView(animation: Animation.named("lf20_vhkdj1ra"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        connection()
        
        defaultAuthHolderViewHeight = authHolderViewHeight.constant
        
        fbLoginButton.delegate = self
        
       fbLoginButton.permissions = ["public_profile", "email"]
            
        //Facebook Chenck Token
        if let token = AccessToken.current,
           !token.isExpired {
            
            animationView.frame = view.bounds

            // Add animationView as subview
            view.addSubview(animationView)

            // Play the animation
            animationView.play()
            animationView.loopMode = .repeat(3.0)
            animationView.animationSpeed = 1
  
            self.fbLoginButton.setTitle("Continue With Facebbok", for: .normal)
            
//            if UserDefaults.standard.value(forKey: "CheckDriverView") != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.type(normal)"]).start(completionHandler: { (connection, result, error) in
                  
                if error == nil {
                    // converting data to JSON
                    guard let json = result as? [String:Any] else {
                    return
                    }
                    print(json)
                    //to save our user data in userModel
                    User.currentUser.setInfo(json: json)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    
                } else {
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                Helper().showAlert(title: "Error!", message: error!.localizedDescription, in: self)
                    print(error?.localizedDescription)
                }
            })
            //self.userType = self.userType.capitalized
                NetworkManager.fbLogin(userType: self.userType,completion:  { success, error in

                    if error == nil {
                        DispatchQueue.main.async {
                            
                        
                        
                        if UserDefaults.standard.value(forKey: "CheckDriverView") != nil {
                            let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                            let ordersVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                            self.showDetailViewController(ordersVC, sender: self)
                        } else {
                            self.userType = self.userType.capitalized
                            self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                        }
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()

                        }
                    } else {
                        DispatchQueue.main.async {
                    print(error?.localizedDescription)
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()
                            Helper().showAlert(title: "Error !", message: error!.rawValue, in: self)
                        }
                    }
                })
           
    }
        if GIDSignIn.sharedInstance.currentUser?.authentication.accessToken != nil {
            
            GIDSignIn.sharedInstance.signIn(with: GoogleManager.signInConfig, presenting: self) { user, error in
                User.currentUser.name = user?.profile?.name
                User.currentUser.email = user?.profile?.email
                if user?.profile?.hasImage  == true{
                User.currentUser.imageURL = user?.profile?.imageURL(withDimension: 100)
                }
            }
            
            NetworkManager.googleLogin(userType: self.userType,completion:  { success, error in
                
                if error == nil {
                    DispatchQueue.main.async {
                        
                        self.userType = self.userType.capitalized
                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()
                    }
                } else {
                    DispatchQueue.main.async {
                        Helper().showAlert(title: "Error!", message: error!.rawValue, in: self)
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()
                    }
                }
            })
        }
        
        configureAuthViewAppearance()
        signInAppleButton()
        checkAutoLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // local bool
        let bIsHidden = authHolderView.isHidden
        
        // if the picker holder view is currently hidden, show it
        if bIsHidden {
            authHolderView.isHidden = false
        }

        
        self.authHolderViewHeight.constant = self.authHolderViewHeight.constant > 0 ? 0 : defaultAuthHolderViewHeight
 
        // animate the change
        UIView.animate(withDuration: 2, animations: {
            self.view.layoutIfNeeded()
//            self.googleLoginButton.updateConstraintsIfNeeded()
        }) { finished in
            // if the picker holder view was showing (NOT hidden)
            //  hide it
//            self.showAuthButton.setTitle("Sign Up To Continue", for: .normal)
            if !bIsHidden {
                self.authHolderView.isHidden  = true
                // disable squeeze button until view is showing again
                self.showAuthButton.setTitle("  Sign Up To Continue", for: .normal)
//                self.view.layoutIfNeeded()s
            } else {
                
                self.showAuthButton.setTitle("  Continue To Order", for: .normal)
                self.showAuthButton.isEnabled = true
                // re-enable squeeze button
                self.showAuthButton.isEnabled = true
//                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        fbLoginButton.layer.cornerRadius = 6
        fbLoginButton.clipsToBounds = true
        
        googleLoginButton.layer.cornerRadius = 6
        googleLoginButton.clipsToBounds = true

    }
    
    func connection() {
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                
                
            } else {
                print("No connection.")
                DispatchQueue.main.async {
                    self.internetConnectionLabel.text = "No Internet Connection"
                    

                    self.view.backgroundColor = UIColor(named: "NoInternetBackground")
                    self.appLogo.backgroundColor = .clear
                    self.showAuthButton.isHidden = true
                    self.authHolderView.isHidden = true
                    self.deliverOrdersButton.isHidden = true
                    self.topLineOfAuthHolderView.isHidden = true
                    let image = UIImage(named: "NoInternetStatus")!
                    self.appLogo.image = image
                    
                }
                
            }
            
            //To Check Whether This Class uses cellular data or Hotspot
            print(path.isExpensive)
        }
        
        //Start Implementation of Checking The Internet Connection
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    
    func configureAuthButton() {
        // Create a gradient layer
                let gradient = CAGradientLayer()

                // gradient colors in order which they will visually appear
                gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]

                // Gradient from left to right
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

                // set the gradient layer to the same size as the view
                gradient.frame = viewForMyButton.bounds

                // add the gradient layer to the views layer for rendering
        viewForMyButton.layer.insertSublayer(gradient, at: 0)

                // Tha magic! Set the button as the views mask
        viewForMyButton.mask = showAuthButton

 
    }
    
    func configureAuthViewAppearance() {
        self.showAuthButton.setTitle("  Sign Up To Continue", for: .normal)
        let bIsHidden = authHolderView.isHidden
        
        // if the authHolder view is currently hidden, show it
        if bIsHidden {
            authHolderView.isHidden = false
        }
        // if authHolder height constant is > 0 (it's open / showing)
        //      set it to 0
        // else
        //      set it to defaultauthHolderViewHeight
        self.authHolderViewHeight.constant = self.authHolderViewHeight.constant > 0 ? 0 : defaultAuthHolderViewHeight
        
   
        //  hide it
        if !bIsHidden {
            self.showAuthButton.setTitle("  Sign Up To Continue", for: .normal)
            self.authHolderView.isHidden  = true
            // disable squeeze button until view is showing again
            self.showAuthButton.isEnabled = true
        } else {
            self.showAuthButton.setTitle("  Continue To Order", for: .normal)
            // re-enable squeeze button
            self.showAuthButton.isEnabled = true
        }
    }
    
        
    
    @IBAction func authButtonClicked(_ sender: Any) {
        self.showAuthButton.setTitle("  Sign Up To Continue", for: .normal)
        // local bool
        let bIsHidden = authHolderView.isHidden
        
        // if the picker holder view is currently hidden, show it
        if bIsHidden {
            authHolderView.isHidden = false
        }
        // if picker holder height constant is > 0 (it's open / showing)
        //      set it to 0
        // else
        //      set it to defaultPickerHolderViewHeight
        
        self.authHolderViewHeight.constant = self.authHolderViewHeight.constant > 0 ? 0 : defaultAuthHolderViewHeight

        // animate the change
        UIView.animate(withDuration: animDuration, animations: {
            self.view.layoutIfNeeded()
        }) { finished in
            // if the picker holder view was showing (NOT hidden)
            //  hide it
//            self.showAuthButton.setTitle("Sign Up To Continue", for: .normal)
            if !bIsHidden {
                self.authHolderView.isHidden  = true
                // disable squeeze button until view is showing again
                self.showAuthButton.setTitle("  Sign Up To Continue", for: .normal)
                
            } else {
                
                self.showAuthButton.setTitle("   Continue To Order", for: .normal)
                self.showAuthButton.isEnabled = true
                // re-enable squeeze button
                self.showAuthButton.isEnabled = true
            }
        }
    }
    
    @IBAction func googleLoginTapped(_ sender: Any) {
        
        GIDSignIn.sharedInstance.signIn(with: GoogleManager.signInConfig, presenting: self) { user, error in
            
            guard error == nil else { return }
            self.animationView.frame = self.view.bounds

            // Add animationView as subview
            self.view.addSubview(self.animationView)

            // Play the animation
            self.animationView.play()
            self.animationView.loopMode = .repeat(3.0)
            self.animationView.animationSpeed = 1
            
            guard let user = user else {
                
                print("user cancelled the request")
                UserDefaults.standard.removeObject(forKey: "CheckDriverView")
                self.animationView.stop()
                self.animationView.removeFromSuperview()
                return
            }
            // If sign in succeeded, display the app's main content View.
            //Updating Data
            User.currentUser.name = user.profile?.name
            User.currentUser.email = user.profile?.email

            if user.profile?.hasImage != nil {
                if let googleImage = user.profile?.imageURL(withDimension: 100) {
                    User.currentUser.imageURL = googleImage
                }
            }

            NetworkManager.googleLogin(userType: self.userType,completion:  { success, error in

                if error == nil {
                    DispatchQueue.main.async {
                        
                    
//                    UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                    self.userType = self.userType.capitalized
                    self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    }

                } else {
                    DispatchQueue.main.async {
                    Helper().showAlert(title: "Error!", message: error!.rawValue, in: self)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    }
                }
            })
            
          }
    }
    

    func loginButton(
        _ loginButton: FBLoginButton,
        didCompleteWith potentialResult: LoginManagerLoginResult?,
        error potentialError: Error?
    ) {
        
        if let error = potentialError {
            // Handle Error
            hud.dismiss()
            print(error)
        }
        
//        if potentialError == nil {
        
        guard let result = potentialResult else {
            // Handle missing result
            return
        }

        guard !result.isCancelled else {
            // Handle cancellation
            print("cancel")
            hud.dismiss()
            return
        }
        // Handle successful login
        FBManager.getFBUserData(completion: {
            self.animationView.frame = self.view.bounds
            
            // Add animationView as subview
            self.view.addSubview(self.animationView)
            
            // Play the animation
            self.animationView.play()
            self.animationView.loopMode = .repeat(3.0)
            self.animationView.animationSpeed = 1
    
            NetworkManager.fbLogin(userType: self.userType,completion:  { success, error in
                
                if error == nil {
                    DispatchQueue.main.async {
                    
                    if UserDefaults.standard.value(forKey: "CheckDriverView") != nil {
                        let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                        let ordersVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        self.showDetailViewController(ordersVC, sender: self)
                    
                    } else {
                        self.userType = self.userType.capitalized
                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                    }
                    
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    self.fbLoginButton.setTitle("Continue With Facebbok", for: .normal)
                    }
                } else {
                    DispatchQueue.main.async {
                        Helper().showAlert(title: "Error!", message: error!.rawValue, in: self)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    print(error!.localizedDescription)
                    }
                    
                }
            })
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
    
    func signInAppleButton() {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        self.authHolderView.addSubview(button)
        NSLayoutConstraint.activate([
                                     button.leadingAnchor.constraint(equalTo: googleLoginButton.leadingAnchor,constant: 0),
                                     button.trailingAnchor.constraint(equalTo: googleLoginButton.trailingAnchor,constant: 0),
            button.topAnchor.constraint(equalTo: fbLoginButton.topAnchor,constant: -46),
            button.heightAnchor.constraint(equalTo: googleLoginButton.heightAnchor)
        ])
        
    }
    
    @objc func handleAppleIdRequest() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let vc = ASAuthorizationController(authorizationRequests: [request])
        vc.delegate = self
        vc.presentationContextProvider = self
        vc.performRequests()
    }
    
    @IBAction func DriverLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
        let driverLoginVC = storyboard.instantiateViewController(withIdentifier: "DriverLoginVC") as! DriverLoginVC
        driverLoginVC.modalPresentationStyle = .fullScreen
        self.present(driverLoginVC, animated: true, completion: nil)
    }
    
    
}

//@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let email = appleIDCredential.email
            UserDefaults.standard.setValue(email, forKey: "appleIdEmail")
            
            
            let fullName = appleIDCredential.fullName
            
            DispatchQueue.main.async {
                
                // Create an account in your system.
                let userIdentifier = appleIDCredential.user
                UserDefaults.standard.setValue(userIdentifier, forKey: "appleUserId")
                
                if let authCode = appleIDCredential.authorizationCode {
                    let authCodeString = String(data: authCode, encoding: .utf8)!
                    print(authCodeString)
                }
               
                if let identityToken = appleIDCredential.identityToken {
                    let identityTokenString = String(data: identityToken, encoding: .utf8)!
                    
                    UserDefaults.standard.setValue(identityTokenString, forKey: "appleIdentityToken")
//                    print(identityTokenString)
                }
                
                if let firstName = fullName?.givenName {
                    AppleUser.currentUser.fullName?.givenName  = firstName
                    UserDefaults.standard.setValue(firstName, forKey: "appleIdFirstName")
                }
                
                if let lastName = fullName?.familyName {
                    AppleUser.currentUser.fullName?.familyName  = lastName
                    UserDefaults.standard.setValue(lastName, forKey: "appleIdLastName")
                }
            
            // The Apple ID credential is valid.
            NetworkManager.appleIDLogin(userType: self.userType,completion:  { success, error in

                if error == nil {
                    if UserDefaults.standard.value(forKey: "CheckDriverView") != nil {
                        let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                        let ordersVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        self.showDetailViewController(ordersVC, sender: self)
                        
                    } else {
                        self.userType = self.userType.capitalized
                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                    }
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()

                } else {
                    Helper().showAlert(title: "Error Occurred!", message: "Login Again", in: self)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                }
            })
        }
            break
               
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
         if let err = error as? ASAuthorizationError {
            
            switch err.code {
            case .canceled:
                appDelegate.infoView(message: "You Cancelled The Login Process", color: colorSmoothRed)

            return
            case .failed:
                Helper().showAlert(title: "Error !", message: "Authorization failed.", in: self)
            case .invalidResponse:
                print("invaliedResponse")
            case .notHandled:
                print("notHandled")

            case .unknown:
               if controller.authorizationRequests.contains(where: { $0 is ASAuthorizationPasswordRequest }) {
               
                //Helper().showAlert(title: "Error !", message:  "Unknown error with password auth, trying to request for appleID auth..", in: self)
                  let requestAppleID = ASAuthorizationAppleIDProvider().createRequest()
                  requestAppleID.requestedScopes = [.email, .fullName]
                  requestAppleID.requestedOperation = .operationImplicit
                  let controller = ASAuthorizationController(authorizationRequests: [requestAppleID])
                  controller.delegate = self
                  controller.presentationContextProvider = self
                  controller.performRequests()
                  return
    } else {
        Helper().showAlert(title: "Error !", message:  "Unknown error for appleID auth.", in: self)
 
    }
       default:
        //Helper().showAlert(title: "Error !", message:  "Unsupported error code.", in: self)
            print("Unsupported error code.")
      }
     }
    }
    
}

//@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
extension LoginVC {

        func checkAutoLogin() {
            
            let userId = UserDefaults.standard.string(forKey: "appleUserId") ?? ""
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            if Constants.appleUserId != nil {
                appleIDProvider.getCredentialState(forUserID:userId) { (credentialState, error) in
            switch credentialState {
                case .authorized:
                    print("Auto login successful")
                        //resume normal app flow
                    NetworkManager.appleIDLogin(userType: self.userType,completion:  { success, error in

                        if error == nil {
                            DispatchQueue.main.async {
                                
                            
                            if UserDefaults.standard.value(forKey: "CheckDriverView") != nil {
                                let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                                let ordersVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//                                ordersVC.modalPresentationStyle = .fullScreen
                                self.showDetailViewController(ordersVC, sender: self )
                            
                            
                                
                            } else {
                                self.userType = self.userType.capitalized
                                self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                            }
                            self.animationView.stop()
                            self.animationView.removeFromSuperview()
                        }
                        } else {
                            DispatchQueue.main.async {
                            Helper().showAlert(title: "Error Occurred!", message: "Please Login Again", in: self)
                            self.animationView.stop()
                            self.animationView.removeFromSuperview()
                            }
                        }
                    })
                
                    
                    break
                case .revoked, .notFound:
                    print("Auto login not successful")
                    //show login screen or you also invoke handleAuthorizationAppleIDAction
                    break
                default:
                    break
                }
            }
        }
    }
}
