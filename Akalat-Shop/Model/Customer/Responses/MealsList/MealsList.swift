//
//  MealsList.swift
//  Akalat Shop
//
//  Created by Macbook on 6/22/21.
//

import Foundation

struct MealsList: Codable {
    
    let meals   : [MealsResult]
    
    enum CodingKeys: String, CodingKey {

        case meals = "meals"
    }
    
}
