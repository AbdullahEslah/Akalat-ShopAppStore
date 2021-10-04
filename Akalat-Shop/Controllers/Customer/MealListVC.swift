//
//  MealListVC.swift
//  EgyStore
//
//  Created by Macbook on 6/8/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit
import JGProgressHUD
import Lottie

class MealListVC: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    
    //Passed data
    var restaurantId  : Int?
    var restaurantName: String?
    var restaurant    : RestaurntsResult?

    @IBOutlet weak var collectionView: UICollectionView!
    let animationView = AnimationView(animation: Animation.named("lf30_editor_reir1nit"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        animationView.frame = view.bounds

        // Add animationView as subview
        view.addSubview(animationView)

        // Play the animation
        animationView.play()
        animationView.loopMode = .repeat(3.0)
        animationView.animationSpeed = 1
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MealsCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "MealsCollectionViewCell")
        mealsList()
        self.navigationItem.title = restaurantName

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor(named: "MainColor")
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .always
       
        collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    	
    //Get All Meals
    func mealsList() {
        //        hud.textLabel.text = "Loading..."
        //        hud.show(in: self.view)
        
        
        NetworkManager.getMealsList(restaurantId: restaurantId ?? 0) { meals, error in
            
            if error == nil {
                print(meals)
                
                ArraysModels.listMeals.removeAll()
                ArraysModels.listMeals.append(contentsOf: meals)
                
                self.animationView.stop()
                self.animationView.removeFromSuperview()
                
                self.collectionView.reloadData()
            }else {
                self.animationView.stop()
                self.animationView.removeFromSuperview()
                Helper().showAlert(title: "Error!", message: error!.localizedDescription, in: self)
            }
        }
        
    }

    
    func setGradientBackground() {
        let colorTop = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let colorBottom =  UIColor(red: 195.0/255.0, green: 86.0/255.0, blue: 77.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
}
extension MealListVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArraysModels.listMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealsCollectionViewCell", for: indexPath) as? MealsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //Configure the cell...
        let mealsData = ArraysModels.listMeals[indexPath.item]
        cell.configureCell(meal: mealsData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mealDetailsVC = storyboard.instantiateViewController(withIdentifier: "MealDetailsVC") as? MealDetailsVC {
            
            let mealsData = ArraysModels.listMeals[indexPath.item]
            
            mealDetailsVC.mealName   = mealsData.name
            mealDetailsVC.mealDesc   = mealsData.short_description
            mealDetailsVC.mealImage  = mealsData.image
            mealDetailsVC.mealPrice  = mealsData.price
            mealDetailsVC.meal       = mealsData
            mealDetailsVC.restaurant = restaurant
            
//         mealDetailsVC.navigationController?.navigationBar.barTintColor = UIColor(named: "MainColor")
            
            self.navigationController?.show(mealDetailsVC, sender: self)
            
        
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 16 ) / 2) // 16 because of paddings
            return CGSize(width: width, height: 180)
    }
    
}
