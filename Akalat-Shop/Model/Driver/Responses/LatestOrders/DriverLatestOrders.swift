//
//  DriverLatestOrders.swift
//  Akalat Shop
//
//  Created by Macbook on 19/07/2021.
//

import Foundation

import Foundation
struct DriverLatestOrders : Codable {
    
    let order             : TheDriverLatestOrderDetails

    enum CodingKeys: String, CodingKey {

        case order = "order"
    }

    
}
