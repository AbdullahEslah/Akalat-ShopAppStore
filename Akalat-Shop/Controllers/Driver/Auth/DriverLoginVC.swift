//
//  DriverLoginVC.swift
//  AkalatShop-Driver
//
//  Created by Macbook on 07/10/2021.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import JGProgressHUD
import Kingfisher
import Lottie
import ObjectiveC

class DriverLoginVC: UIViewController, LoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var viewForMyButton: UIView!
    @IBOutlet weak var showAuthButton: UIButton!
    //Objects
    @IBOutlet weak var authHolderView: UIView!
   
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
   
    @IBOutlet weak var authHolderViewHeight: NSLayoutConstraint!
    
    
    
    var userID :String?
    //Handle Appearnace Of AuthView
    var defaultAuthHolderViewHeight : CGFloat = 0.0
    
    //Anim duration - change to something like 1.0 to see the effect in "slo-motion"
    let animDuration                = 1.0
    
    let hud                = JGProgressHUD(style: .dark)
    var userType : String  = NetworkManager.Auth.userTypeDriver
    
    let animationView = AnimationView(animation: Animation.named("lf20_vhkdj1ra"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        defaultAuthHolderViewHeight = authHolderViewHeight.constant
        
        // Conforms To Google Protocol
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().clientID = "970857005723-hgran64vnmn3avdqeanvl3eq4seteau7.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "970857005723-10rkfjuhvj9r2d58o550qfoi4fbk1vpk.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/userinfo.email")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/userinfo.profile")
//        GIDSignIn.sharedInstance()?.signInSilently()
        
        
        fbLoginButton.delegate = self
        
        fbLoginButton.permissions = ["public_profile", "email"]
        
        
        configureAuthViewAppearance()
        signInAppleButton()
        
        //AppleAutoLogin
//        checkAutoLogin()
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
                
                self.showAuthButton.setTitle("  Continue To Deliver Orders", for: .normal)
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
            self.showAuthButton.setTitle("  Continue To Deliver Orders", for: .normal)
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
                
                self.showAuthButton.setTitle("  Continue To Deliver Orders", for: .normal)
                self.showAuthButton.isEnabled = true
                // re-enable squeeze button
                self.showAuthButton.isEnabled = true
            }
        }
    }

    func loginButton(
        _ loginButton: FBLoginButton,
        didCompleteWith potentialResult: LoginManagerLoginResult?,
        error potentialError: Error?
    ) {
        
        if let error = potentialError {
            UserDefaults.standard.removeObject(forKey: "CheckDriverView")
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
            UserDefaults.standard.removeObject(forKey: "CheckDriverView")
            print("cancel")
            hud.dismiss()
            return
        }
        
            
//            DispatchQueue.main.async {
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
                            
                            UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                            self.userType = self.userType.capitalized
                            self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                            
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
//    }
            
            
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
                UserDefaults.standard.removeObject(forKey: "CheckDriverView")
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
                    UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                    self.userType = self.userType.capitalized
                    self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()

                } else {
                    Helper().showAlert(title: "Error!", message: error!.localizedDescription, in: self)
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                }
            })
        } else {
            UserDefaults.standard.removeObject(forKey: "CheckDriverView")
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
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

//@available(iOS 13.0, *)
extension DriverLoginVC: ASAuthorizationControllerDelegate {
    
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
                    UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                    self.userType = self.userType.capitalized
                    self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
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
                UserDefaults.standard.removeObject(forKey: "CheckDriverView")

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
        UserDefaults.standard.removeObject(forKey: "CheckDriverView")
        //Helper().showAlert(title: "Error !", message:  "Unknown error for appleID auth.", in: self)
 
        print("Unknown error for appleID auth.")
    }
       default:
        //Helper().showAlert(title: "Error !", message:  "Unsupported error code.", in: self)
            print("Unsupported error code.")
      }
     }
    }
    
}

//@available(iOS 13.0, *)
extension DriverLoginVC: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

    



