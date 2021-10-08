//
//  RefreshToken.swift
//  Akalat Shop
//
//  Created by Macbook on 6/19/21.
//

import Foundation

struct RefreshToken  : Codable {
    
    let grant_type   : String
    let client_id    : String
    let client_secret: String
    let refresh_token: String
    
}
