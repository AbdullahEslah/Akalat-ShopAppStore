//
//  Logout.swift
//  Akalat Shop
//
//  Created by Macbook on 6/18/21.
//

import Foundation

struct LogoutRevokeToken: Codable {
    
    let client_id    : String
    let client_secret: String
    let token        : String
    
}
