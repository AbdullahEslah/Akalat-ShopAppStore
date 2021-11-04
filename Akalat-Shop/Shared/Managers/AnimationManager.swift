//
//  AnimationManager.swift
//  Akalat-Shop
//
//  Created by Macbook on 29/10/2021.
//

import Foundation
import UIKit

class AnimationManager {
    
    class var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    class var screenRight: CGPoint {
        return CGPoint(x: screenBounds.maxX, y: screenBounds.minY)
    }
    
    class var screenLeft: CGPoint {
        return CGPoint(x: screenBounds.minX, y: screenBounds.minY)
    }
    
}
