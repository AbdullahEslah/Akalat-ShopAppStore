//
//  GFError.swift
//  Akalat-Shop
//
//  Created by Macbook on 11/10/2021.
//

import Foundation

enum GFError: String, Error {
    case invalidResponse  = "Invalid Response From The Server Please Try Again"
    case invalidData      = "The Data Received From The Server Was Invalid Please Try Again"
    case UnAbleToComplete = "Unable To Complete. Please Check Your Internet Connection"
}
