//
//  MealsResult.swift
//  Akalat Shop
//
//  Created by Macbook on 6/22/21.
//

import Foundation

struct MealsResult: Codable {
    
    let id                : Int
    let name              : String
    let short_description : String
    let image             : String
    let price             : Float
    
    enum CodingKeys: String, CodingKey {

        case id                = "id"
        case name              = "name"
        case short_description = "short_description"
        case image             = "image"
        case price             = "price"
    }
    
}
