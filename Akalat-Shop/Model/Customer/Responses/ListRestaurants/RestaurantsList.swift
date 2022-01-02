//
//  RestaurantsList.swift
//  Akalat Shop
//
//  Created by Macbook on 6/20/21.
//

import Foundation

class RestaurantsList: Codable {
    
    let restaurants  : [RestaurntsResult]
    
    enum CodingKeys: String, CodingKey {

        case restaurants 
    }
    
}
