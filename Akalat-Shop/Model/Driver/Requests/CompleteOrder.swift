//
//  CompleteOrder.swift
//  Akalat-Shop
//
//  Created by Macbook on 16/10/2021.
//

import Foundation

struct CompleteOrder : Codable {
    
    let access_token : String
    let order_id     : Int
    
    enum CodingKeys       : String, CodingKey {
        
        case access_token = "access_token"
        case order_id     = "order_id"
        
    }
    
    
}
