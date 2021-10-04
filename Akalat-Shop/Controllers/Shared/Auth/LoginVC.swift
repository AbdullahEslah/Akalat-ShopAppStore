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
import ObjectiveC

class LoginVC: UIViewController, LoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var viewForMyButton: UIView!
    @IBOutlet weak var showAuthButton: UIButton!
    //Objects
    @IBOutlet weak var authHolderView: UIView!
   
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
   
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
   
    
    //Constraints
    @IBOutlet weak var appleButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var fbButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var authHolderViewHeight: NSLayoutConstraint!
    
    
    //Variables
    var fbLoginSuccess     = false
    var googleLoginSuccess = false
    var userID :String?
    //Handle Appearnace Of AuthView
    var defaultAuthHolderViewHeight : CGFloat = 0.0
    
    //Anim duration - change to something like 1.0 to see the effect in "slo-motion"
    let animDuration                = 1.0
    
    let hud                = JGProgressHUD(style: .dark)
    var userType : String  = NetworkManager.Auth.userTypeCustomer
    
//    let signInConfig = GIDConfiguration.init(clientID: "970857005723-hgran64vnmn3avdqeanvl3eq4seteau7.apps.googleusercontent.com")
    
    let animationView = AnimationView(animation: Animation.named("lf30_editor_reir1nit"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        defaultAuthHolderViewHeight = 0
//        showAuthButton.gradientButton("Continue To Order", startColor:.purple, endColor: colorSmoothRed)
//        configureAuthButton()
        
        defaultAuthHolderViewHeight = authHolderViewHeight.constant
   
        // Conforms To Google Protocol
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
//        kGIDSignInButtonColorSchemeLight

        
        GIDSignIn.sharedInstance().clientID = "970857005723-hgran64vnmn3avdqeanvl3eq4seteau7.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "970857005723-10rkfjuhvj9r2d58o550qfoi4fbk1vpk.apps.googleusercontent.com"

        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/userinfo.email")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/userinfo.profile")
        GIDSignIn.sharedInstance()?.signInSilently()
            
        
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
                }
            })
            self.userType = self.userType.capitalized
                NetworkManager.fbLogin(userType: self.userType,completion:  { success, error in

                    if error == nil {

                        self.userType = self.userType.capitalized
                        if UserDefaults.standard.value(forKey: "CustomerOrDriver") != nil {
//                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                        self.performSegue(withIdentifier: "\(UserDefaults.standard.value(forKey: "CustomerOrDriver")!)View", sender: self)
                        } else {
                            self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                        }
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()

                    } else {
                    print(error?.localizedDescription)
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()
                        Helper().showAlert(title: "Error !", message: error!.localizedDescription, in: self)
                    }
                })
        }
        configureSegmentControl()
        configureAuthViewAppearance()
        signInAppleButton()
        
        //AppleAutoLogin
        checkAutoLogin()
//        performExistingAccountSetupFlows()
//        ImplementSegue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        //        appleButtonHeight.constant = 0
//        fbButtonHeight.constant    = 0
        
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
//        signInAppleButton()
//        self.view.layoutIfNeeded()
//        appleLoginButton.layer.cornerRadius = appleLoginButton.frame.width / 2
//        appleLoginButton.clipsToBounds = true
//
//        googleLoginButton.layer.cornerRadius = googleLoginButton.frame.width / 2
//        googleLoginButton.clipsToBounds = true
//
//        fbLoginButton.layer.cornerRadius = fbLoginButton.frame.height / 2
//        fbLoginButton.clipsToBounds = true
//
    }
    
    
    
    func configureSegmentControl() {
        let font = UIFont.systemFont(ofSize: 20)
        
        let normalAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.gray]
        segmentControl.setTitleTextAttributes(normalAttribute, for: .normal)
        
        let selectedAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(selectedAttribute, for: .selected)
        
        segmentControl.setTitle("Order Now", forSegmentAt: 0)
        segmentControl.setTitle("Be A Driver", forSegmentAt: 1)
        
        if #available(iOS 9.0, *) {
            UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 1
        }
        
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

                //Set corner Radius and border Width of button
//                showAuthButton.layer.cornerRadius =  showAuthButton.frame.size.height / 2
//        showAuthButton.layer.borderWidth = 5.0
            
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
        
    //        appleButtonHeight.constant = 0
    //        fbButtonHeight.constant    = 0
       
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
        //        appleButtonHeight.constant = 0
//        fbButtonHeight.constant    = 0
        
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
                
                self.showAuthButton.setTitle("  Continue To Order", for: .normal)
                self.showAuthButton.isEnabled = true
                // re-enable squeeze button
                self.showAuthButton.isEnabled = true
            }
        }
    }
    
    
    
    func loginSuccessForGoogle(animated: Bool){
        self.userType = self.userType.capitalized
        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
    }
    
    func loginButton(
        _ loginButton: FBLoginButton,
        didCompleteWith potentialResult: LoginManagerLoginResult?,
        error potentialError: Error?
    ) {
        
        if let error = potentialError {
            // Handle Error
            UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
            print(UserDefaults.standard.value(forKey: "CustomerOrDriver"))
            hud.dismiss()
            print(error)
        }
        
        guard let result = potentialResult else {
            // Handle missing result
            return
        }

        guard !result.isCancelled else {
            // Handle cancellation
            UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
            print(UserDefaults.standard.value(forKey: "CustomerOrDriver"))
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
                    
                    self.userType = self.userType.capitalized
                    if UserDefaults.standard.value(forKey: "CustomerOrDriver") != nil {
                        
                        self.performSegue(withIdentifier: "\(UserDefaults.standard.value(forKey: "CustomerOrDriver")!)View", sender: self)
                        
                    } else {
                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                    }
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    self.fbLoginButton.setTitle("Continue With Facebbok", for: .normal)
                    
                } else {
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    print(error!.localizedDescription)
                    
                }
            })
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        self.animationView.frame = self.view.bounds

        // Add animationView as subview
        self.view.addSubview(self.animationView)

        // Play the animation
        self.animationView.play()
        self.animationView.loopMode = .repeat(3.0)
        self.animationView.animationSpeed = 1

        if error == nil {

            guard let user = user else {
                print("user cancelled the request")
                UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
                print(UserDefaults.standard.value(forKey: "CustomerOrDriver"))
                self.animationView.stop()
                self.animationView.removeFromSuperview()
                return
            }

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

                    self.userType = self.userType.capitalized
                    
                    if UserDefaults.standard.value(forKey: "CustomerOrDriver") != nil {
                        self.performSegue(withIdentifier: "\(UserDefaults.standard.value(forKey: "CustomerOrDriver")!)View", sender: self)
                    }else {
                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                    }
 
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()

                } else {
                    Helper().showAlert(title: "Error!", message: error!.localizedDescription, in: self)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                }
            })
        } else {

            UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
            print(UserDefaults.standard.value(forKey: "CustomerOrDriver"))
            self.animationView.stop()
            self.animationView.removeFromSuperview()
        }
    }

    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {

    }
    
    func signInAppleButton() {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        self.authHolderView.addSubview(button)
        NSLayoutConstraint.activate([
                                     button.leadingAnchor.constraint(equalTo: googleLoginButton.leadingAnchor,constant: 4),
                                     button.trailingAnchor.constraint(equalTo: googleLoginButton.trailingAnchor,constant: -4),
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
    
    @IBAction func appleLoginTapped(_ sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let vc = ASAuthorizationController(authorizationRequests: [request])
        vc.delegate = self
        vc.presentationContextProvider = self
        vc.performRequests()
    }
    
     //- Tag: perform_appleid_password_request
    // Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        
        if Constants.appleUserId != nil {
        
            // Prepare requests for both Apple ID and password providers.
            let requests = [ASAuthorizationAppleIDProvider().createRequest()
                            ]
//            ASAuthorizationPasswordProvider().createRequest()
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        
        
        let type = segmentControl.selectedSegmentIndex
        
        let defaults = UserDefaults.standard
        if type == 0 {
            userType = NetworkManager.Auth.userTypeCustomer
            
            defaults.setValue(userType.capitalized, forKey: "CustomerOrDriver")
            
        } else {
            userType = NetworkManager.Auth.userTypeDriver
            defaults.setValue(userType.capitalized, forKey: "CustomerOrDriver")
            
        }
        print(UserDefaults.standard.value(forKey: "CustomerOrDriver") ?? "")
    }
    
}



//@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let email = appleIDCredential.email
            UserDefaults.standard.setValue(email, forKey: "appleIdEmail")
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            UserDefaults.standard.setValue(userIdentifier, forKey: "appleUserId")
            
            let fullName = appleIDCredential.fullName
//            appleIDCredential.
            
            DispatchQueue.main.async {
                
                if let authCode = appleIDCredential.authorizationCode {
                    let authCodeString = String(data: authCode, encoding: .utf8)!
                    print(authCodeString)
                }
               
                if let identityToken = appleIDCredential.identityToken {
                    let identityTokenString = String(data: identityToken, encoding: .utf8)!
//                    NetworkManager.Auth.accessToken = identityTokenString
                    
                    UserDefaults.standard.setValue(identityTokenString, forKey: "appleIdentityToken")
                    print(identityTokenString)
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

                    self.userType = self.userType.capitalized
                    
                    if UserDefaults.standard.value(forKey: "CustomerOrDriver") != nil {
//                        DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "\(UserDefaults.standard.value(forKey: "CustomerOrDriver")!)View", sender: self)
                    }else {
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
                UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
            return
            case .failed:
                Helper().showAlert(title: "Error !", message: "Authorization failed.", in: self)
                UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
            case .invalidResponse:
                Helper().showAlert(title: "Error !", message: "Authorization returned invalid response.", in: self)
                UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
            case .notHandled:
                Helper().showAlert(title: "Error !", message:  "Authorization not handled.", in: self)
                UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")

            case .unknown:
               if controller.authorizationRequests.contains(where: { $0 is ASAuthorizationPasswordRequest }) {
                UserDefaults.standard.removeObject(forKey: "CustomerOrDriver")
                Helper().showAlert(title: "Error !", message:  "Unknown error with password auth, trying to request for appleID auth..", in: self)

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
        Helper().showAlert(title: "Error !", message:  "Unsupported error code.", in: self)

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

                            self.userType = self.userType.capitalized
                            
                            if UserDefaults.standard.value(forKey: "CustomerOrDriver") != nil {
                                self.performSegue(withIdentifier: "\(UserDefaults.standard.value(forKey: "CustomerOrDriver")!)View", sender: self)
                            }else {
                                self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                            }
         
                            self.animationView.stop()
                            self.animationView.removeFromSuperview()

                        } else {
                            Helper().showAlert(title: "Error Occurred!", message: "Please Login Again", in: self)
                            self.animationView.stop()
                            self.animationView.removeFromSuperview()
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
    



