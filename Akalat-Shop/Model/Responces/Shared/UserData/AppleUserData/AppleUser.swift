//
//  AppleUser.swift
//  Akalat Shop
//
//  Created by Macbook on 20/09/2021.
//

import Foundation
import AuthenticationServices

class AppleUser {
    
    var fullName   : PersonNameComponents?
    var appleEmail : String?
    
    static let currentUser = AppleUser()
    
//    init(credentials: ASAuthorizationAppleIDCredential) {
//        self.appleEmail = credentials.email ?? ""
//        self.name = "\(credentials.fullName?.givenName ?? "") \(credentials.fullName?.givenName ?? "")"
//
//    }
    
     func resetInfo() {
        self.fullName = nil
//        self.fullName = nil
//        self.fullName?.givenName = nil
        self.appleEmail = nil
        
    }
}
