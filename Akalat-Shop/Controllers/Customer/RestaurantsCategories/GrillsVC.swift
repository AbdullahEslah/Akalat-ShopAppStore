//
//  GrillsVC.swift
//  Akalat Shop
//
//  Created by Macbook on 21/07/2021.
//

import UIKit
import Kingfisher
import SkeletonView

class GrillsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add Animation For CollectionView
        self.collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: .none, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
            fetchFirstRestaurants()
        })
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomRestaurantLayoutCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell")
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    func fetchFirstRestaurants(){
        
        NetworkManager.getRestaurantsCategories(restaurantCategory: Constants.Grills) { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.collectionView.stopSkeletonAnimation()
                    self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    
                    ArraysModels.restGrills.removeAll()
                    ArraysModels.restGrills.append(contentsOf: restaurants)
                    self.collectionView.reloadData()
                
            }
            }else {
                DispatchQueue.main.async {
                    self.collectionView.stopSkeletonAnimation()
                    self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
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

extension GrillsVC: SkeletonCollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CustomRestaurantLayoutCollectionViewCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return ArraysModels.restGrills.count
      
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //Configure the cell...
        let restaurantsData = ArraysModels.restGrills[indexPath.row]
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
        let restaurantsData = ArraysModels.restGrills[indexPath.row]
        //go to MealsListVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC

        mealListVC.restaurantId   = restaurantsData.id
        mealListVC.restaurantName = restaurantsData.name
        mealListVC.restaurant     = restaurantsData
        navigationController?.show(mealListVC, sender: self)
       
    }
}
