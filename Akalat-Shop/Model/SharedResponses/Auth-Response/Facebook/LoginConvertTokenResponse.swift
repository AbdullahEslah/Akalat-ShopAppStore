//
//  GenerateAccessTokenResponse.swift
//  Akalat Shop
//
//  Created by Macbook on 6/18/21.
//

import Foundation

struct LoginConvertTokenResponse : Codable {
    
    let access_token : String
    let expires_in   : Int
    let token_type   : String
    let scope        : String
    let refresh_token: String
    
}
