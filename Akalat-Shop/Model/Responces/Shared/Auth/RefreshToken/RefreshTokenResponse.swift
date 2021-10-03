//
//  RefreshTokenResponse.swift
//  Akalat Shop
//
//  Created by Macbook on 6/19/21.
//

import Foundation

struct RefreshTokenResponse: Codable {
    let access_token : String
    let expires_in   : Int
    let token_type   : String
    let scope        : String
    let refresh_token: String
}
