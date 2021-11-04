//
//  Tray.swift
//  Akalat Shop
//
//  Created by Macbook on 7/1/21.
//

import Foundation

class TrayItem {
    
    var meal     : MealsResult
    var qty      : Int
    var delivery : RestaurntsResult
    
    
    init(meal: MealsResult, qty: Int, delivery: RestaurntsResult) {
        
        self.meal     = meal
        self.qty      = qty
        self.delivery = delivery
        
    }
}

class Tray {
    
    static let currentTray = Tray()
    
    var restaurant         : RestaurntsResult?
    var items              = [TrayItem]()
    var address            : String?
    var Phone              : String?
    
    func getTotal() -> Float {
        
        var total   : Float = 0
        
        for item in self.items {
            total = total + Float(item.qty) * item.meal.price 
        }
        return total
    }
    
    func reset() {
        self.restaurant = nil
        self.items      = []
        self.address    = nil
        self.Phone      = nil
    }
}
