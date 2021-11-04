//
//  CategoryVC.swift
//  Akalat Shop
//
//  Created by Macbook on 21/07/2021.
//

import UIKit
import Kingfisher
import JGProgressHUD
import Lottie

class SandwichesVC: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    let animationView = AnimationView(animation: Animation.named("lf20_vhkdj1ra"))
    let menuButton = UIButton(type: .custom)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.frame = view.bounds

        // Add animationView as subview
        view.addSubview(animationView)

        // Play the animation
        animationView.play()
        animationView.loopMode = .repeat(3.0)
        animationView.animationSpeed = 1

        collectionView.register(UINib(nibName: "CustomRestaurantLayoutCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell")
        collectionView.collectionViewLayout = createCompositionalLayout()
        fetchFirstRestaurants()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    func fetchFirstRestaurants(){
        
        NetworkManager.getRestaurantsCategories(restaurantCategory: Constants.Sandwiches) { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                print(ArraysModels.restCategories)
                ArraysModels.restCategories.removeAll()
                
                ArraysModels.restCategories.append(contentsOf: restaurants)
                self.collectionView.reloadData()
                self.animationView.stop()
                self.animationView.removeFromSuperview()
            }
            }else {
                DispatchQueue.main.async {
                    self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
                self.animationView.stop()
                self.animationView.removeFromSuperview()
                }
            }
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
      let inset: CGFloat = 8

      // Large item on top
      let topItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16))
      let topItem = NSCollectionLayoutItem(layoutSize: topItemSize)
      topItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

      // Bottom item
      let bottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
      let bottomItem = NSCollectionLayoutItem(layoutSize: bottomItemSize)
      bottomItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

      // Group for bottom item, it repeats the bottom item twice
      let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
      let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize, subitem: bottomItem, count: 2)

      // Combine the top item and bottom group
      let fullGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16 + 0.5))
      let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: fullGroupSize, subitems: [topItem, bottomGroup])

      let section = NSCollectionLayoutSection(group: nestedGroup)

      let layout = UICollectionViewCompositionalLayout(section: section)

      return layout
    }
    
}

extension SandwichesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return ArraysModels.restCategories.count
      

    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //Configure the cell...
        let restaurantsData = ArraysModels.restCategories[indexPath.row]
        cell.restaurantName.text = restaurantsData.name
        
        if let url = URL(string: restaurantsData.logo) {
            let placeholder = UIImage(named: "contact-bg")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            cell.restaurantImage.kf.indicatorType = .activity
            cell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
            
        }
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //access Rest Id to show it's meals via api
        let restaurantsData = ArraysModels.restCategories[indexPath.row]
        //go to MealsListVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC

        mealListVC.restaurantId   = restaurantsData.id
        mealListVC.restaurantName = restaurantsData.name
        mealListVC.restaurant     = restaurantsData
        navigationController?.show(mealListVC, sender: self)
       
    }
}
