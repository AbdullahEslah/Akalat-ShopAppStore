//
//  CreateAccessToken.swift
//  Akalat Shop
//
//  Created by Macbook on 6/18/21.
//

import Foundation

struct GoogleLoginConvertToken : Codable {
    
    let grant_type    : String
    let backend       : String
    let user_type     : String
    let client_id     : String
    let client_secret : String
    let token         : String
    
}
