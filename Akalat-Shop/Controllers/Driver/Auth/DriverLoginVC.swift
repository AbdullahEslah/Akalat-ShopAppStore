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
import Network

class DriverLoginVC: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appLogo: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var internetConnectionLabel: UILabel!
    
    @IBOutlet weak var viewForMyButton: UIView!
    @IBOutlet weak var topLineOfAuthHolderView: RoundedShadowView!
    @IBOutlet weak var showAuthButton: UIButton!
    //Objects
    @IBOutlet weak var authHolderView: UIView!
   
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
   
    @IBOutlet weak var authHolderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var termsOfUseButton: UIButton!
    @IBOutlet weak var termsOfUseStackView: UIStackView!
    @IBOutlet weak var privacyPolicyStackView: UIStackView!
    
    //For Translating Them
    @IBOutlet weak var termPhraseLeftLabel: UILabel!
    @IBOutlet weak var termPhraseRightLabel: UILabel!
    
    @IBOutlet weak var privacyPhraseLeft: UILabel!
    @IBOutlet weak var privacyPhraseRight: UILabel!
    
    
    var userID :String?
    //Handle Appearnace Of AuthView
    var defaultAuthHolderViewHeight : CGFloat = 0.0
    
    //Anim duration - change to something like 1.0 to see the effect in "slo-motion"
    let animDuration                = 1.0
    
    let hud                = JGProgressHUD(style: .dark)
    var userType : String  = NetworkManager.Auth.userTypeDriver
    let monitor            = NWPathMonitor()
    
    
    let animationView = AnimationView(animation: Animation.named("lf20_vhkdj1ra"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localizedTermsOfUseButton = NSLocalizedString("Terms Of Use", comment: "")
        termsOfUseButton.setTitle(localizedTermsOfUseButton, for: .normal)

        let localizedPolicyOfOurCommunityButton = NSLocalizedString("Policy Of Our Community", comment: "")
        privacyPolicyButton.setTitle(localizedPolicyOfOurCommunityButton, for: .normal)
  
        let localizedLeftPhrase  = NSLocalizedString("By Clicking One Of The Top Buttons You Accept", comment: "")
        termPhraseLeftLabel.text = localizedLeftPhrase
        
        let localizedRightPhrase  = NSLocalizedString("Of Our App", comment: "")
        termPhraseRightLabel.text = localizedRightPhrase
        
        let privacyLocalizedLeftPhrase  = NSLocalizedString("And To The", comment: "")
        privacyPhraseLeft.text = privacyLocalizedLeftPhrase
        
        let privacyLocalizedRightPhrase = NSLocalizedString("Please Read Them Before Using The App", comment: "")
        privacyPhraseRight.text = privacyLocalizedRightPhrase
        
        connection()
        defaultAuthHolderViewHeight = authHolderViewHeight.constant
        
        fbLoginButton.delegate = self
        
        fbLoginButton.permissions = ["public_profile", "email"]
        
        //Facebook Chenck Token
        if let token = AccessToken.current,
           !token.isExpired {
            
            let screenSize: CGRect = UIScreen.main.bounds
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 300))
            label.text = "Akalat-Shop"
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Iceland", size: 62)
            self.view.addSubview(label)
            
            appNameLabel.isHidden = true
            internetConnectionLabel.isHidden = true
            appLogo.isHidden = true
            showAuthButton.isHidden = true
            topLineOfAuthHolderView.isHidden = true
            authHolderView.isHidden = true
            self.googleLoginButton.isHidden = true
            self.fbLoginButton.isHidden = true
            self.termsOfUseStackView.isHidden = true
            self.privacyPolicyStackView.isHidden = true
            self.backButton.isHidden = true
            
            animationView.frame = view.bounds
            // Add animationView as subview
            view.addSubview(animationView)

            // Play the animation
            animationView.play()
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            
            GraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.type(normal)"]).start(completionHandler: { (connection, result, error) in
                
                if error == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                            self.animationView.alpha = 0
                        }completion: { (_) in
                    // converting data to JSON
                    guard let json = result as? [String:Any] else {
                        return
                    }
                    print(json)
                    //to save our user data in userModel
                    User.currentUser.setInfo(json: json)
                            
                            self.animationView.stop()
                        }
                    })
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                            self.animationView.alpha = 0
                        }completion: { (_) in
                    self.animationView.stop()
                    Helper().showAlert(title: "Error!", message: error!.localizedDescription, in: self)
                        }
                    })
                }
            })
            //self.userType = self.userType.capitalized
            NetworkManager.fbLogin(userType: self.userType,completion:  { success, error in
                
                if error == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                            self.animationView.alpha = 0
                        }completion: { (_) in
                        
                        self.userType = self.userType.capitalized
                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                        //                        }
                            self.animationView.stop()
                                }
                            })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                            self.animationView.alpha = 0
                        }completion: { (_) in
                            self.animationView.stop()
                        Helper().showAlert(title: "Error !", message: error!.localizedDescription, in: self)
                        }
                    })
                }
            })
        }
        
        if GIDSignIn.sharedInstance.currentUser?.authentication.accessToken != nil {
            
            let screenSize: CGRect = UIScreen.main.bounds
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 300))
            label.text = "Akalat-Shop"
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Iceland", size: 62)
            self.view.addSubview(label)
            
            appNameLabel.isHidden = true
            internetConnectionLabel.isHidden = true
            appLogo.isHidden = true
            showAuthButton.isHidden = true
            topLineOfAuthHolderView.isHidden = true
            authHolderView.isHidden = true
            self.googleLoginButton.isHidden = true
            self.fbLoginButton.isHidden = true
            self.termsOfUseStackView.isHidden = true
            self.privacyPolicyStackView.isHidden = true
            self.backButton.isHidden = true
            
            
            animationView.frame = view.bounds
            // Add animationView as subview
            view.addSubview(animationView)

            // Play the animation
            animationView.play()
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            
            GIDSignIn.sharedInstance.signIn(with: GoogleManager.signInConfig, presenting: self) { user, error in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                    UIView.animate(withDuration: 3.0) {
                        self.animationView.alpha = 0
                    }completion: { (_) in
                User.currentUser.name = user?.profile?.name
                User.currentUser.email = user?.profile?.email
                if user?.profile?.hasImage  == true{
                User.currentUser.imageURL = user?.profile?.imageURL(withDimension: 100)
                }
                    }
                })
            }
            
            NetworkManager.googleLogin(userType: self.userType,completion:  { success, error in
                
                
                    if error == nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                            UIView.animate(withDuration: 3.0) {
                                self.animationView.alpha = 0
                            }completion: { (_) in
                                UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                                self.userType = self.userType.capitalized
                                self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                                self.animationView.stop()
                                
                            }
                        })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                            self.animationView.alpha = 0
                        }completion: { (_) in
                        Helper().showAlert(title: "Error!", message: error!.localizedDescription, in: self)
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()
                        }
                    })
                }
            })
        }
        
        configureAuthViewAppearance()
        signInAppleButton()
        //AppleAutoLogin
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
                    let image = UIImage(named: "NoInternetStatus")!

                    self.view.backgroundColor = UIColor(named: "NoInternetBackground")
                    self.appLogo.backgroundColor = .clear
                    self.showAuthButton.isHidden = true
                    self.authHolderView.isHidden = true
                    self.topLineOfAuthHolderView.isHidden = true
                    self.privacyPolicyStackView.isHidden = true
                    self.termsOfUseStackView.isHidden = true
                    self.backButton.isHidden = true
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
    
    
    @IBAction func googleSignInTapped(_ sender: Any) {
        
        self.hud.textLabel.text = "Loading..."
        self.hud.show(in: self.view)
        
        GIDSignIn.sharedInstance.signIn(with: GoogleManager.signInConfig, presenting: self) { user, error in
            
            guard error == nil else {
                self.hud.dismiss()
                return
            }
           
            
            guard let user = user else {
                UserDefaults.standard.removeObject(forKey: "CheckDriverView")
                self.hud.dismiss()
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                        }completion: { (_) in
                            UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                            self.userType = self.userType.capitalized
                            self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                            self.hud.dismiss()
                        }
                        
                    })
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                        }completion: { (_) in
                            Helper().showAlert(title: "Error!", message: error!.rawValue, in: self)
                            self.hud.dismiss()
                        }
                    })
                }
            })
            
        }
    }
    

    func loginButton(
        _ loginButton: FBLoginButton,
        didCompleteWith potentialResult: LoginManagerLoginResult?,
        error potentialError: Error?
    ) {
        
        self.hud.textLabel.text = "Loading..."
        self.hud.show(in: self.view)
        
        if let error = potentialError {
            UserDefaults.standard.removeObject(forKey: "CheckDriverView")
            // Handle Error
            self.hud.dismiss()
            print(error)
        }
        
        guard let result = potentialResult else {
            // Handle missing result
            self.hud.dismiss()
            return
        }

        guard !result.isCancelled else {
            // Handle cancellation
            UserDefaults.standard.removeObject(forKey: "CheckDriverView")
            self.hud.dismiss()
            return
        }
        
        // Handle successful login
        FBManager.getFBUserData(completion: {
            
            NetworkManager.fbLogin(userType: self.userType,completion:  { success, error in
                
                if error == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                        }completion: { (_) in
                            self.hud.dismiss()
                            UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                            self.userType = self.userType.capitalized
                            self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                            self.fbLoginButton.setTitle("Continue With Facebbok", for: .normal)
                        }
                    })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                        }completion: { (_) in
                        Helper().showAlert(title: "Error~", message: error!.rawValue, in: self)
                            self.hud.dismiss()
                        }
                    })
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
            button.topAnchor.constraint(equalTo: fbLoginButton.topAnchor,constant: -45),
            button.heightAnchor.constraint(equalTo: googleLoginButton.heightAnchor)
        ])
        
        if let token = AccessToken.current,
           !token.isExpired {
            button.isHidden = true
        }
        
        if GIDSignIn.sharedInstance.currentUser?.authentication.accessToken != nil {
        
            button.isHidden = true
        }
        
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

//@available(iOS 13.0, *)
extension DriverLoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            self.hud.textLabel.text = "Loading..."
            self.hud.show(in: self.view)
            
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                        }completion: { (_) in
                    UserDefaults.standard.setValue("DriverView", forKey: "CheckDriverView")
                    self.userType = self.userType.capitalized
                    self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                    self.hud.dismiss()
                    
                    }
                    })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                        UIView.animate(withDuration: 3.0) {
                        }completion: { (_) in
                    Helper().showAlert(title: "Error Occurred!", message: "Login Again", in: self)
                            self.hud.dismiss()
                        }
                    })
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
                self.hud.dismiss()

            return
            case .failed:
                Helper().showAlert(title: "Error !", message: "Authorization failed.", in: self)
                self.hud.dismiss()
            case .invalidResponse:
                print("invaliedResponse")
                self.hud.dismiss()
            case .notHandled:
                print("notHandled")
                self.hud.dismiss()

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
        self.hud.dismiss()
        UserDefaults.standard.removeObject(forKey: "CheckDriverView")
        //Helper().showAlert(title: "Error !", message:  "Unknown error for appleID auth.", in: self)
        print("Unknown error for appleID auth.")
        
    }
       default:
        //Helper().showAlert(title: "Error !", message:  "Unsupported error code.", in: self)
        self.hud.dismiss()
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

extension DriverLoginVC {
    
    func checkAutoLogin() {
        
        let userId = UserDefaults.standard.string(forKey: "appleUserId") ?? ""
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        if Constants.appleUserId != nil {
        
        DispatchQueue.main.async {
            
            let screenSize: CGRect = UIScreen.main.bounds
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 300))
            label.text = "Akalat-Shop"
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Iceland", size: 62)
            self.view.addSubview(label)
            
            self.appNameLabel.isHidden = true
            self.internetConnectionLabel.isHidden = true
            self.appLogo.isHidden = true
            self.showAuthButton.isHidden = true
            self.topLineOfAuthHolderView.isHidden = true
            self.authHolderView.isHidden = true
            self.googleLoginButton.isHidden = true
            self.fbLoginButton.isHidden = true
            self.termsOfUseStackView.isHidden = true
            self.privacyPolicyStackView.isHidden = true
            self.backButton.isHidden = true
            
            
            self.animationView.frame = self.view.bounds
            // Add animationView as subview
            self.view.addSubview(self.animationView)
            
            // Play the animation
            self.animationView.play()
            self.animationView.loopMode = .loop
            self.animationView.animationSpeed = 1
           
                appleIDProvider.getCredentialState(forUserID:userId) { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        print("Auto login successful")
                        //resume normal app flow
                        NetworkManager.appleIDLogin(userType: self.userType,completion:  { success, error in
                            
                            if error == nil {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                                    UIView.animate(withDuration: 3.0) {
                                        self.animationView.alpha = 0
                                    }completion: { (_) in
                                        
                                        self.userType = self.userType.capitalized
                                        self.performSegue(withIdentifier: "\(self.userType)View", sender: self)
                                        
                                        self.animationView.stop()
                                    }
                                })
                                
                                
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute:  {
                                    UIView.animate(withDuration: 3.0) {
                                        self.animationView.alpha = 0
                                    }completion: { (_) in
//                                        Helper().showAlert(title: "Error Occurred!", message: "Please Login Again", in: self)
                                        UserDefaults.standard.removeObject(forKey: "appleUserId")
                                        let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                                        let loginVC = storyboard.instantiateViewController(identifier: "DriverLoginVC")
                                        appDelegate.window!.rootViewController = loginVC
                                        self.animationView.stop()
                                    }
                                })
                            }
                        })
                        
                        
                        break
                    case .revoked, .notFound:
                        print("Auto login not successful")
                        //show login screen or you also invoke handleAuthorizationAppleIDAction
                        DispatchQueue.main.async {
                            
                            self.animationView.stop()
                            self.animationView.alpha = 0
                            self.appNameLabel.isHidden = false
                            self.internetConnectionLabel.isHidden = false
                            self.appLogo.isHidden = false
                            self.showAuthButton.isHidden = false
                            self.topLineOfAuthHolderView.isHidden = false
                            self.authHolderView.isHidden = false
                            self.googleLoginButton.isHidden = false
                            self.fbLoginButton.isHidden = false
                            self.termsOfUseStackView.isHidden = false
                            self.privacyPolicyStackView.isHidden = false
                            
                            label.removeFromSuperview()
                        }
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
}

    



