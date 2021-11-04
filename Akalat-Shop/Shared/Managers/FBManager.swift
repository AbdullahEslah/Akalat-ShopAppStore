//
//  FBManagerClient.swift
//  EgyStore
//
//  Created by Macbook on 6/16/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import Foundation
import FBSDKLoginKit


class FBManager {
    
    static let shared = LoginManager()
    
    public class func getFBUserData(completion: @escaping () -> Void ) {
        
        if AccessToken.current != nil {
            
            GraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.type(normal)"]).start(completionHandler: { (connection, result, error) in
                  
                if error == nil {
                    // converting data to JSON
                    guard let json = result as? [String:Any] else {
                    return
                    }
                    print(json)
                    //to save our user data in userModel
                    User.currentUser.setInfo(json: json)
                    completion()
                }
            })
        }
        
    }
}
