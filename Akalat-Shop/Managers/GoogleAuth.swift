//
//  GoogleAuth.swift
//  Akalat Shop
//
//  Created by Macbook on 21/08/2021.
//

//import Foundation
//
//class GoogleAuth {
//    public class func getToken(completion: @escaping () ->Void) {
//        let authorizationEndpoint : NSURL = NSURL(string:
//                                                    "https://accounts.google.com/o/oauth2/v2/auth/access_type=offline")!
//        let tokenEndpoint : NSURL = NSURL(string: "https://oauth2.googleapis.com/token")!
//        
//        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint as URL, tokenEndpoint: tokenEndpoint as URL)
//        
//        let request  = OIDAuthorizationRequest.init(configuration: configuration, clientId: "970857005723-hgran64vnmn3avdqeanvl3eq4seteau7.apps.googleusercontent.com", scopes: [OIDScopeOpenID], redirectURL: URL(string: "com.googleusercontent.apps.970857005723-hgran64vnmn3avdqeanvl3eq4seteau7:/oauth2redirect/google")!, responseType: OIDResponseTypeCode, additionalParameters: nil)
//        
//        //performs authentication request
//        print("Initiating authorization request with scope: \(request.scope ?? "nil")")
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        
//        appDelegate.currentAuthorizationFlow =
//            OIDAuthState.authState(byPresenting: request, presenting: LoginVC(), callback: { (authState, error) in
//                
//                
////                if authState != nil     {
//                    
//                    guard let authState = authState?.lastTokenResponse?.accessToken else {
//                        
//                        return
//                    }
//                    NetworkManager.Auth.accessToken = authState
//                    
//                    completion()
////                }
//            })
//    }
//}
