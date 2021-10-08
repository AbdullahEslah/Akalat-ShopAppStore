//
//  AppleID.swift
//  Akalat-Shop
//
//  Created by Macbook on 01/10/2021.
//

import Foundation

struct AppleIDLogin : Codable {
    
    let grant_type   : String
    let backend      : String
    let user_type    : String
    let client_id    : String
    let client_secret: String
    let token        : String
    
}
