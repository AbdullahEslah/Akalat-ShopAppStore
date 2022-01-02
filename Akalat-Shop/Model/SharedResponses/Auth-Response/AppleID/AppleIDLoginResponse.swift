//
//  AppleIDLoginResponse.swift
//  Akalat-Shop
//
//  Created by Macbook on 01/10/2021.
//

import Foundation

struct AppleIDLoginResponse : Codable {
    
    let access_token : String
    let expires_in   : Int
    let token_type   : String
    let scope        : String
    let refresh_token: String
    
    enum CodingKeys: String, CodingKey {

        case access_token  = "access_token"
        case expires_in    = "expires_in"
        case token_type    = "token_type"
        case scope         = "scope"
        case refresh_token = "refresh_token"
    }
    
    
}
