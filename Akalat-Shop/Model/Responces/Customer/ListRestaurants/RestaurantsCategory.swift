//
//  RestaurantsList.swift
//  Akalat Shop
//
//  Created by Macbook on 6/20/21.
//

import Foundation

class RestaurantsCategory: Codable {
    
    let restaurants  : [RestaurntsCategoryResults]
    
    enum CodingKeys: String, CodingKey {

        case restaurants 
    }
    
}
