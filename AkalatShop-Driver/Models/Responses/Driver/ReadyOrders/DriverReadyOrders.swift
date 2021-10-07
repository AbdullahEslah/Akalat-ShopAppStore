//
//  DriverLatestOrders.swift
//  Akalat Shop
//
//  Created by Macbook on 19/07/2021.
//

import Foundation

import Foundation
struct DriverReadyOrders : Codable {
    
    let orders             : [TheDriverOrderDetails]

    enum CodingKeys: String, CodingKey {

        case orders = "orders"
    }

    
}
