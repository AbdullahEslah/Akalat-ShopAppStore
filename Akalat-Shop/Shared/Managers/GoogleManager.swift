//
//  GoogleManager.swift
//  Akalat Shop
//
//  Created by Macbook on 14/08/2021.
//

import Foundation
import GoogleSignIn
import Alamofire


class GoogleManager {
    
//    static let shared = GIDSignIn.sharedInstance
    
    static let signInConfig = GIDConfiguration.init(clientID: "970857005723-hgran64vnmn3avdqeanvl3eq4seteau7.apps.googleusercontent.com",serverClientID: "970857005723-10rkfjuhvj9r2d58o550qfoi4fbk1vpk.apps.googleusercontent.com")
    
//    public class func getGoogleUserData(completion: @escaping () -> Void ) {
//
////        if GIDSignIn.sharedInstance()?.currentUser?.authentication.accessToken != nil {
//
//            func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//                guard let user = user else {
//                    print("Uh oh. The user cancelled the Google login.")
//
//                    return
//                }
//
//                //Updating Data
//                User.currentUser.name = user.profile?.name
//                User.currentUser.email = user.profile?.email
//
//                if user.profile?.hasImage != nil {
//                    if let googleImage = user.profile?.imageURL(withDimension: 100) {
//                        User.currentUser.imageURL = googleImage
//                    }
//                }
////                NetworkManager.Auth.accessToken = user.authentication.accessToken
//                completion()
//            }
////        }
//    }
}
