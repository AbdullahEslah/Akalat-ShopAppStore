//
//  GenerateAccessTokenResponse.swift
//  Akalat Shop
//
//  Created by Macbook on 6/18/21.
//

import Foundation

struct GoogleLoginConvertTokenResponse : Codable {
    
    let access_token : String
    let expires_in   : Int
    let scope        : String
    let refresh_token: String
    
}
