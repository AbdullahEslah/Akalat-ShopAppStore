//
//  MealDetailsVC.swift
//  EgyStore
//
//  Created by Macbook on 6/10/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class MealDetailsVC: UIViewController {
    
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealDescLabel: UILabel!
    @IBOutlet weak var basketBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var numOfitemsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //Passed Data
    var mealImage: String?
    var mealName : String?
    var mealDesc : String?
    var mealPrice: Float?
    
    //For add and remove items
    var items = 1
    
    //For handling add items from different restaurants
    var restaurant: RestaurntsResult?
    var meal      : MealsResult?
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mealData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
   
    @IBAction func addItem(_ sender: Any) {
        
        //if we don't have itemsthen increese items by one and show it in numOfItemsLabel
        if items < 99 {
            items += 1
            numOfitemsLabel.text = String(items)
            
            if let price = mealPrice {
                
                priceLabel.text = "\(price  * Float(items)) EG"
            }
        }
    }
    @IBAction func removeItem(_ sender: Any) {

        //if items is bigger than 1 so we do have items then decrease them by one and show them in numOfItemsLabel
        if items >= 2 {
            items -= 1
            numOfitemsLabel.text = String(items)
            
            if let price = mealPrice {
                priceLabel.text = "\(price  * Float(items)) EG"
            }
        }
    }
    @IBAction func addToBasket(_ sender: Any) {
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        image.image = UIImage(named: "Basket")
        image.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 100)
        self.view.addSubview(image)
        
        if AppLocalization.currentAppleLanguage() == "en" {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { image.center = AnimationManager.screenRight
                        image.alpha = 0.0},
                       completion: { _ in
                        image.removeFromSuperview()
                        
                        
                        guard let mealItem = self.meal else {
                            return
                        }
                        
                        let trayItem = TrayItem(meal: mealItem, qty: self.items, delivery: self.restaurant!)
                        
                        guard let trayRestaurant = Tray.currentTray.restaurant, let currentRestaurant = self.restaurant else {
                            
                            // If those requirements are not met
                            Tray.currentTray.restaurant = self.restaurant
                            Tray.currentTray.items.append(trayItem)
                            return
                        }
                        
                        
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        
                        // If ordering meal from the same restaurant
                        if trayRestaurant.id == currentRestaurant.id {
                            
                            let inTray = Tray.currentTray.items.firstIndex(where: { (item) -> Bool in
                                
                                return item.meal.id == trayItem.meal.id
                            })
                            
                            if let index = inTray {
                                
                                let alertView = UIAlertController(
                                    title: "Add more?",
                                    message: "Your tray already has this meal. Do you want to add more?",
                                    preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "Add more", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    Tray.currentTray.items[index].qty += self.items
                                })
                                
                                alertView.addAction(okAction)
                                alertView.addAction(cancelAction)
                                
                                self.present(alertView, animated: true, completion: nil)
                            } else {
                                Tray.currentTray.items.append(trayItem)
                            }
                            
                        }
                        else {// If ordering meal from the another restaurant
                            
                            let alertView = UIAlertController(
                                title: "Start new tray?",
                                message: "You're ordering meal from another restaurant. Would you like to clear the current tray?",
                                preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "New Tray", style: .default, handler: { (action: UIAlertAction!) in
                                
                                Tray.currentTray.items = []
                                Tray.currentTray.items.append(trayItem)
                                Tray.currentTray.restaurant = self.restaurant
                            })
                            
                            alertView.addAction(okAction)
                            alertView.addAction(cancelAction)
                            
                            self.present(alertView, animated: true, completion: nil)
                        }
                       })
            
        }else {
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: { image.center = AnimationManager.screenLeft
                            image.alpha = 0.0},
                           completion: { _ in
                            image.removeFromSuperview()
                            
                            
                            guard let mealItem = self.meal else {
                                return
                            }
                            
                            let trayItem = TrayItem(meal: mealItem, qty: self.items, delivery: self.restaurant!)
                            
                            guard let trayRestaurant = Tray.currentTray.restaurant, let currentRestaurant = self.restaurant else {
                                
                                // If those requirements are not met
                                Tray.currentTray.restaurant = self.restaurant
                                Tray.currentTray.items.append(trayItem)
                                return
                            }
                            
                            
                            
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            
                            // If ordering meal from the same restaurant
                            if trayRestaurant.id == currentRestaurant.id {
                                
                                let inTray = Tray.currentTray.items.firstIndex(where: { (item) -> Bool in
                                    
                                    return item.meal.id == trayItem.meal.id
                                })
                                
                                if let index = inTray {
                                    
                                    let alertView = UIAlertController(
                                        title: "Add more?",
                                        message: "Your tray already has this meal. Do you want to add more?",
                                        preferredStyle: .alert)
                                    
                                    let okAction = UIAlertAction(title: "Add more", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        Tray.currentTray.items[index].qty += self.items
                                    })
                                    
                                    alertView.addAction(okAction)
                                    alertView.addAction(cancelAction)
                                    
                                    self.present(alertView, animated: true, completion: nil)
                                } else {
                                    Tray.currentTray.items.append(trayItem)
                                }
                                
                            }
                            else {// If ordering meal from the another restaurant
                                
                                let alertView = UIAlertController(
                                    title: "Start new tray?",
                                    message: "You're ordering meal from another restaurant. Would you like to clear the current tray?",
                                    preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "New Tray", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    Tray.currentTray.items = []
                                    Tray.currentTray.items.append(trayItem)
                                    Tray.currentTray.restaurant = self.restaurant
                                })
                                
                                alertView.addAction(okAction)
                                alertView.addAction(cancelAction)
                                
                                self.present(alertView, animated: true, completion: nil)
                            }
                           })
            
        }
    }
    
    func mealData() {
               
        priceLabel.text = "\(mealPrice ?? 0) EG"
        mealNameLabel.text   = mealName
        mealDescLabel.text   = mealDesc
        
        if let url = URL(string: mealImage ?? "") {
            let placeholder = UIImage(named: "contact-bg")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            mealImageView.kf.indicatorType = .activity
            mealImageView.kf.setImage(with: url,placeholder: placeholder,options: options)
        }
        
    }
}
