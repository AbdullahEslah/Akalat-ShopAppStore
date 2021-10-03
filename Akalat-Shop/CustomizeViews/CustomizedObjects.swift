//
//  RoundedViews.swift
//  One
//
//  Created by Macbook on 11/17/20.
//  Copyright © 2020 Abdallah Eslah. All rights reserved.
//

import UIKit
class RoundedButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = self.frame.height / 2
    }
}

class StopPasteAction: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class RoundedButtonView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }
}

class RoundedImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius: CGFloat = self.bounds.size.width / 2.0

        self.layer.cornerRadius = radius
    }
}


class TextFieldPadding : UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
         layer.borderWidth = 1.0
        layer.borderColor = UIColor(named:"MainColor")?.cgColor
    }
   
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


class RoundedShadowView : UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = shapeLayer
        
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

extension UIView{

    func gradientButton(_ buttonText:String, startColor:UIColor, endColor:UIColor) {

        let button:UIButton = UIButton(frame: self.bounds)
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 22)
        button.setImage(UIImage(named: "arrow.right.circle.fill")?.withTintColor(UIColor(named: "SmoothRed")!), for: .normal)
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor,endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient.point
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.mask = button

//        button.layer.cornerRadius =  button.frame.size.height / 2
//        button.layer.borderWidth = 5.0
    }
}

class RoundedCustomizedVisualEffectView : UIVisualEffectView{

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMaskLayer()
    }

    func updateMaskLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = shapeLayer
    }
}

class RoundedVisualEffectView : UIVisualEffectView{

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMaskLayer()
    }

    func updateMaskLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
        self.layer.mask = shapeLayer
    }
}



class sheetShape : UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
}


class RoundedImageView : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }
}
    
    class CustomRoundedImageView : UIImageView {
        override func layoutSubviews() {
            super.layoutSubviews()
            updateMaskLayer()
        }
        
        func updateMaskLayer() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            self.layer.mask = shapeLayer
        }
    }

extension UIView {
    enum ViewSide {
        case Top, Bottom, Left, Right
    }

    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color.cgColor

        switch side {
        case .Top:
            border.frame = CGRect(x: 20, y: 0, width: frame.size.width - 40, height: thickness)
        case .Bottom:
            border.frame = CGRect(x: 0, y: frame.size.height - thickness, width: frame.size.width, height: thickness)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.size.height)
        case .Right:
            border.frame = CGRect(x: frame.size.width - thickness, y: 0, width: thickness, height: frame.size.height)
        }

        layer.addSublayer(border)
    }
}

    

