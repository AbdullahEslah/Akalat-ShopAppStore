//
//  PickOrder.swift
//  Akalat Shop
//
//  Created by Macbook on 04/09/2021.
//

import Foundation

struct PickOrder: Codable {
    
    let status  : String
    let message : String
    
    enum CodingKeys: String, CodingKey {

        case status  = "status"
        case message = "message"
       
    }
}

