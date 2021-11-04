//
//  CompleteOrderResponse.swift
//  Akalat-Shop
//
//  Created by Macbook on 16/10/2021.
//

import Foundation

struct CompleteOrderResponse: Codable {
    
    let status              : String
    
    enum CodingKeys         : String, CodingKey {
        
        case status = "status"
        
    }
}
