//
//  ModelsArrays.swift
//  Akalat Shop
//
//  Created by Macbook on 6/20/21.
//

import Foundation

//Arrays Shared Between Customer - Driver
class ArraysModels {
    
    //Customer
    static var regions             = [RestaurntsResult]()
    
    static var onBordingContents   = [OnBoarding]()

    static var restaurants         = [RestaurntsResult]()
    
    static var rest                : RestaurntsResult?
    
    static var listMeals           = [MealsResult]()
    
    static var listAllMeals        = [MealsResult]()
 
    static var listOrders          = [OrderDetails]()
    
    //Categories
    static var restCategories      = [RestaurntsResult]()
    static var restGrills          = [RestaurntsResult]()
    static var restFriedChicken    = [RestaurntsResult]()
    static var restFish            = [RestaurntsResult]()
    static var restDesserts        = [RestaurntsResult]()
    static var restPizza           = [RestaurntsResult]()
    
   
    
    //Driver
    static var driverReadyOrders   = [TheDriverOrderDetails]()
    static var driverLatestOrders  = [LatestDriverOrderDetails]()
   
}
