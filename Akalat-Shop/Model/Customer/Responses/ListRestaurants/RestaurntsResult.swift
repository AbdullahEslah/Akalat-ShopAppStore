//
//  RestaurntsResult.swift
//  Akalat Shop
//
//  Created by Macbook on 6/20/21.
//

import Foundation

struct RestaurntsResult: Codable {
    
    let id      : Int
    let name    : String
    let phone   : String
    let address : String
    let logo    : String
    let category: String
    let delivery: Float
    
    enum CodingKeys: String, CodingKey {

        case id       = "id"
        case name     = "name"
        case phone    = "phone"
        case address  = "address"
        case logo     = "logo"
        case category = "category"
        case delivery = "delivery"
    }
    
}
