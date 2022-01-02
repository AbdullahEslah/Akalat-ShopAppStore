//
//  HeaderLocalization.swift
//  Akalat-Shop
//
//  Created by Macbook on 01/11/2021.
//

import Foundation
import UIKit

class MirroringLabel: UILabel {
    override func layoutSubviews() {
        if self.tag < 0 {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right {
                    return
                }
            } else {
                if self.textAlignment == .left {
                    return
                }
            }
        }
        if self.tag < 0 {
            if UIApplication.isRTL()  {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
    }

}
