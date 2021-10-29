//
//  FirstVC.swift
//  EgyStore
//
//  Created by Macbook on 11/7/20.
//  Copyright © 2020 Abdallah Eslah. All rights reserved.
//

import UIKit
import Kingfisher
import JGProgressHUD
import Lottie


class RestaurantsVC: UIViewController, UISearchControllerDelegate, SWRevealViewControllerDelegate {

  
    @IBOutlet weak var menuBarButton : UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    static var sectionHeaderElementKind = "header"
    
    
    let menuButton         = UIButton(type: .custom)
    
    // Declare the serachBar In Nav Bar
    let searchBar          = UISearchBar()
    
    var filterdRestaurants = [RestaurntsResult]()
    
    var timer: Timer?
    var currentCellIndex = 0
    let animationView = AnimationView(animation: Animation.named("lf20_vhkdj1ra"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        DispatchQueue.main.async { [weak self] in
            self?.startTimer()
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.register(UINib(nibName: "ScrollViewCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "ScrollViewCollectionViewCell")
        
        collectionView.register(UINib(nibName: "CustomRestaurantLayoutCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell")
        
        collectionView.register(UINib(nibName: "RestaurantsHeaderCollectionReusableView", bundle: nil),forSupplementaryViewOfKind: "header",withReuseIdentifier:"RestaurantsHeaderCollectionReusableView")
 
        fetchRestaurants()
        
        //Categories
        fetchSandwichesRestaurants()
        fetchFishRestaurants()
        fetchPizzaRestaurants()
        fetchGrillsRestaurants()
        fetchDessertsRestaurants()
        fetchFriedChickenRestaurants()
       
        collectionView.collectionViewLayout = createcompositionalLayout()
        animationView.frame = view.bounds

        // Add animationView as subview
        view.addSubview(animationView)

        // Play the animation
        animationView.play()
        animationView.loopMode = .repeat(3.0)
        animationView.animationSpeed = 1
        DismissSearchBar()
        fetchSandwichesRestaurants()
        
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        
//        if currentCellIndex < filterdRestaurants.count {
//
////            collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
//            currentCellIndex += 1
//        }
//        else {
//
//            collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
//            currentCellIndex = 0
//        }
        
    }
   
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        collectionView.reloadData()
       

        configureSearchBar()
       
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("FirstViewController will disappear")
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - <SearchBar>
    fileprivate func configureSearchBar() {
       
        searchBar.placeholder = "Restaurants Search.. "
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.titleView = searchBar
        
        // accessing childView - textField inside of the searchBar
        let searchBar_textField = searchBar.value(forKey: "searchField") as? UITextField
        searchBar_textField?.textColor = .white
        searchBar_textField?.tintColor = .white
        searchBar.delegate = self
        
        // insert searchBar into navigationBar
        self.navigationItem.titleView = searchBar
        
        navigationController?.navigationBar.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = nil
        
        
        menuButton.setImage(UIImage (named: "icon_menu_24dp"), for: .normal)
        
        menuButton.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        if AppLocalization.currentAppleLanguage() == "ar" {
            if self.revealViewController() != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sidemenuViewController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                revealViewController().rightViewController = sidemenuViewController
                revealViewController().delegate = self
                self.revealViewController().rightViewRevealWidth = self.view.frame.width * 0.8
                menuButton.addTarget(self.revealViewController(),
                                     action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
            }
        } else {
            if self.revealViewController() != nil {
                menuButton.addTarget(self.revealViewController(),
                                     action: #selector(revealViewController().revealToggle(_:)),
                                     for: .touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
        
        let barButtonItem = UIBarButtonItem(customView: menuButton)
        
        let button2 = UIButton(type: .custom)
        button2.isUserInteractionEnabled = false
        button2.setImage(UIImage (named: "LogoWithoutName"), for: .normal)
        button2.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        //button.addTarget(target, action: nil, for: .touchUpInside)

        let barButtonItem2 = UIBarButtonItem(customView: button2)
        self.navigationItem.leftBarButtonItems = [barButtonItem, barButtonItem2]
        
    }
    
    func DismissSearchBar() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    
    func createcompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self](index, enviroment) -> NSCollectionLayoutSection? in
            
            return self?.createSectionFor(index: index, enviroment: enviroment)
        }
        return layout
    }
    
    func createSectionFor(index:Int , enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        switch index {
        
        case 0:
            return  createFirstSection()
            
        case 1:
            return createOneSizeSection()
            
        case 2:
            return createOneSizeSection()
            
        case 3:
            return createOneSizeSection()
        
        case 4:
            return createOneSizeSection()
            
        case 5:
            return createOneSizeSection()
            
        case 6:
            return createOneSizeSection()
            
        default:
            return createOneSizeSection()
            
        }
    }

    func createFirstSection() -> NSCollectionLayoutSection {
        
        // Define Item Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))

           // Create Item
           let item = NSCollectionLayoutItem(layoutSize: itemSize)

           // Define Group Size
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))

           // Create Group
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])

           // Create Section
           let section = NSCollectionLayoutSection(group: group)

        return section
    }
   
    
    func createOneSizeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
        .fractionalHeight(1))

           let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15

        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 5)
        
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension:
        .fractionalWidth(0.5))

           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 2)

           let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        
        //header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        let headerTrailing = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .topTrailing)
        
        let headerLeading = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .topLeading)
        
        if AppLocalization.currentAppleLanguage() == "en" {
            section.boundarySupplementaryItems = [headerLeading]
        } else {
            section.boundarySupplementaryItems = [headerTrailing]
        }
        
           return section
    }
    
    
    
    func createList() -> NSCollectionLayoutSection {
//         The Size Of The Item is  100% of the Width of the Container and the height of the layoutSize is 100% of the height of the container
//        (عرض ال cell
        //             وطول الview)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //To Add More Spaces From All Sides
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //                 (عرض ال View
        //             وطول cell ال)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        //add spacing between two sides of items
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        
        //header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        //                let layout = NSCollectionViewCompositionalLayout(section: section)
        return section
            

    }

    
    // Requests
    func fetchRestaurants() {
        
        NetworkManager.getRestaurantsList(restaurantAddress: Constants.region ?? "") { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    
                    ArraysModels.restaurants.removeAll()
                    //            self.filterdRestaurants.removeAll()
                    ArraysModels.restaurants.append(contentsOf: restaurants)
                    
                    self.filterdRestaurants = ArraysModels.restaurants
                    
                    //                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.presentGFAlertOnMainThread(title: "Error!", message: error!.rawValue , buttonTitle: "Ok")
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                }
            }
            
        }
        
    }
    
    func fetchSandwichesRestaurants() {
        
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
    
    func fetchGrillsRestaurants() {
        
        NetworkManager.getRestaurantsCategories(restaurantCategory: Constants.Grills) { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    ArraysModels.restGrills.removeAll()
                    
                    ArraysModels.restGrills.append(contentsOf: restaurants)
                    
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
    
    func fetchPizzaRestaurants() {
        
        NetworkManager.getRestaurantsCategories(restaurantCategory: Constants.Pizza) { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    ArraysModels.restPizza.removeAll()
                    
                    ArraysModels.restPizza.append(contentsOf: restaurants)
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
    
    func fetchFriedChickenRestaurants() {
        
        NetworkManager.getRestaurantsCategories(restaurantCategory: Constants.FriedChicken) { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    ArraysModels.restFriedChicken.removeAll()
                    
                    ArraysModels.restFriedChicken.append(contentsOf: restaurants)
                    
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
    
    func fetchFishRestaurants() {
        
        NetworkManager.getRestaurantsCategories(restaurantCategory: Constants.Fish) { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    ArraysModels.restFish.removeAll()
                    
                    ArraysModels.restFish.append(contentsOf: restaurants)
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
    
    func fetchDessertsRestaurants() {
        
        NetworkManager.getRestaurantsCategories(restaurantCategory: Constants.Desserts) { restaurants, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    ArraysModels.restDesserts.removeAll()
                    
                    ArraysModels.restDesserts.append(contentsOf: restaurants)
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
    

}
    
extension RestaurantsVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if section == 0 {
//            return filterdRestaurants.count
         if section == 1 {
            return filterdRestaurants.count
        } else if section == 2 {
            return ArraysModels.restCategories.count
        } else if section == 3 {
            return ArraysModels.restPizza.count
        } else if section == 4 {
            return ArraysModels.restFriedChicken.count
        } else if section == 5 {
            return ArraysModels.restGrills.count
        } else if section == 6 {
            return ArraysModels.restFish.count
        } else  {
            return ArraysModels.restDesserts.count
        }
        
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = self.collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "RestaurantsHeaderCollectionReusableView", for: indexPath) as? RestaurantsHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
//        if let header = collectionView.supplementaryView(forElementKind: "header", at: IndexPath(item: 1, section: indexPath.section)) as? RestaurantsHeaderCollectionReusableView {
//            // Do your stuff here
//            header.headerLabel.textAlignment = .natural // or whatever
//        }
        
        view.headerLabel.lineBreakMode = .byTruncatingTail
        view.headerLabel.textAlignment = .justified
        view.headerLabel.numberOfLines = 0
        let commonChoicesLabel = NSLocalizedString("browseByAllRestaurantskey", comment: "")
        view.headerLabel.text = indexPath.section == 1 ? commonChoicesLabel : "Common Choices"
        
       
        
        return view
        
    }
   
    
    
   
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        
        case 0:
            guard let CellNumZero = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrollViewCollectionViewCell", for: indexPath) as? ScrollViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            CellNumZero.sandwichesButton.addTarget(self, action: #selector(sandwicthVCAction), for: .touchUpInside)
            CellNumZero.pizzaButton.addTarget(self, action: #selector(pizzaVCAction), for: .touchUpInside)
            CellNumZero.friedChickenButton.addTarget(self, action: #selector(friedChickenVCAction), for: .touchUpInside)
            CellNumZero.grillsButton.addTarget(self, action: #selector(grillsVCAction), for: .touchUpInside)
            CellNumZero.fishButton.addTarget(self, action: #selector(fishVCAction), for: .touchUpInside)
            CellNumZero.dessertsButton.addTarget(self, action: #selector(dessertVCAction), for: .touchUpInside)
            
            return CellNumZero
            
        case 1:
            
            guard let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            
//            //Configure the cell...
            let restaurantsData = filterdRestaurants[indexPath.row]
            firstCell.restaurantName.text = restaurantsData.name


            if let url = URL(string: restaurantsData.logo) {
                let placeholder = UIImage(named: "LogoWithoutName")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                firstCell.restaurantImage.kf.indicatorType = .activity
                firstCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)

            }
            return firstCell
            
            
        
        case 2:
            guard let secCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            //Configure the cell...
            let restaurantsData = ArraysModels.restCategories[indexPath.row]
            secCell.restaurantName.text = restaurantsData.name
            
            
            if let url = URL(string: restaurantsData.logo) {
                let placeholder = UIImage(named: "LogoWithoutName")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                secCell.restaurantImage.kf.indicatorType = .activity
                secCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
                
            }
            return secCell
            
        case 3:
            
            guard let thirdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            //Configure the cell...
            let restaurantsData = ArraysModels.restPizza[indexPath.row]
            thirdCell.restaurantName.text = restaurantsData.name
            
            
            if let url = URL(string: restaurantsData.logo) {
                let placeholder = UIImage(named: "LogoWithoutName")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                thirdCell.restaurantImage.kf.indicatorType = .activity
                thirdCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
                
            }
            return thirdCell
            
        case 4:
            
            guard let fourthCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            //Configure the cell...
            let restaurantsData = ArraysModels.restFriedChicken[indexPath.row]
            fourthCell.restaurantName.text = restaurantsData.name
            
            
            if let url = URL(string: restaurantsData.logo) {
                let placeholder = UIImage(named: "LogoWithoutName")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                fourthCell.restaurantImage.kf.indicatorType = .activity
                fourthCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
                
            }
            return fourthCell
            
        case 5:
            
            guard let fifthCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            //Configure the cell...
            let restaurantsData = ArraysModels.restGrills[indexPath.row]
            fifthCell.restaurantName.text = restaurantsData.name
            
            
            if let url = URL(string: restaurantsData.logo) {
                let placeholder = UIImage(named: "LogoWithoutName")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                fifthCell.restaurantImage.kf.indicatorType = .activity
                fifthCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
                
            }
            return fifthCell
            
        case 6:
            
            guard let sixthCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            //Configure the cell...
            let restaurantsData = ArraysModels.restFish[indexPath.row]
            sixthCell.restaurantName.text = restaurantsData.name
            
            
            if let url = URL(string: restaurantsData.logo) {
                let placeholder = UIImage(named: "LogoWithoutName")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                sixthCell.restaurantImage.kf.indicatorType = .activity
                sixthCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
                
            }
            return sixthCell
            
        case 7:
            
            guard let seventhCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            //Configure the cell...
            let restaurantsData = ArraysModels.restDesserts[indexPath.row]
            seventhCell.restaurantName.text = restaurantsData.name
            
            
            if let url = URL(string: restaurantsData.logo) {
                let placeholder = UIImage(named: "LogoWithoutName")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                seventhCell.restaurantImage.kf.indicatorType = .activity
                seventhCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
                
            }
            return seventhCell
            
            
        default:
            print("error")
        }
        return UICollectionViewCell()
        
    }
    
    
    @objc func sandwicthVCAction() {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        if let sandwichesVC = storyboard.instantiateViewController(withIdentifier: "SandwichesVC") as? SandwichesVC {
            navigationController?.show(sandwichesVC, sender: self)
        }
    }
    
    @objc func pizzaVCAction() {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        if let pizzaVC = storyboard.instantiateViewController(withIdentifier: "PizzaVC") as? PizzaVC {
            navigationController?.show(pizzaVC, sender: self)
        }
    }
    
    @objc func friedChickenVCAction() {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        if let friedChickenVC = storyboard.instantiateViewController(withIdentifier: "FriedChickenVC") as? FriedChickenVC {
            navigationController?.show(friedChickenVC, sender: self)
        }
    }
    
    @objc func grillsVCAction() {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        if let grillsVC = storyboard.instantiateViewController(withIdentifier: "GrillsVC") as? GrillsVC {
            navigationController?.show(grillsVC, sender: self)
        }
    }
    
    @objc func fishVCAction() {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        if let fishVC = storyboard.instantiateViewController(withIdentifier: "FishVC") as? FishVC {
            navigationController?.show(fishVC, sender: self)
        }
    }
    
    @objc func dessertVCAction() {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        if let dessertsVC = storyboard.instantiateViewController(withIdentifier: "DessertsVC") as? DessertsVC {
            navigationController?.show(dessertsVC, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "YourFontname", size: 14.0)
//        header.textLabel?.textAlignment = NSTextAlignment.right
    }
    
    

    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        
        case 1:
            
            //access Rest Id to show it's meals via api
            let restaurantsData = filterdRestaurants[indexPath.row]
            //go to MealsListVC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC
            
            mealListVC.restaurantId   = restaurantsData.id
            mealListVC.restaurantName = restaurantsData.name
            mealListVC.restaurant     = restaurantsData
            navigationController?.show(mealListVC, sender: self)
        
        case 2:
            
            //access Rest Id to show it's meals via api
            let restaurantsData = ArraysModels.restCategories[indexPath.row]
            //go to MealsListVC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC
            
            mealListVC.restaurantId   = restaurantsData.id
            mealListVC.restaurantName = restaurantsData.name
            mealListVC.restaurant     = restaurantsData
            navigationController?.show(mealListVC, sender: self)
            
        case 3:
            
            //access Rest Id to show it's meals via api
            let restaurantsData = ArraysModels.restPizza[indexPath.row]
            //go to MealsListVC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC
            
            mealListVC.restaurantId   = restaurantsData.id
            mealListVC.restaurantName = restaurantsData.name
            mealListVC.restaurant     = restaurantsData
            navigationController?.show(mealListVC, sender: self)
            
        case 4:
            
            //access Rest Id to show it's meals via api
            let restaurantsData = ArraysModels.restFriedChicken[indexPath.row]
            //go to MealsListVC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC
            
            mealListVC.restaurantId   = restaurantsData.id
            mealListVC.restaurantName = restaurantsData.name
            mealListVC.restaurant     = restaurantsData
            navigationController?.show(mealListVC, sender: self)
            
        case 5:
            
            //access Rest Id to show it's meals via api
            let restaurantsData = ArraysModels.restGrills[indexPath.row]
            //go to MealsListVC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC
            
            mealListVC.restaurantId   = restaurantsData.id
            mealListVC.restaurantName = restaurantsData.name
            mealListVC.restaurant     = restaurantsData
            navigationController?.show(mealListVC, sender: self)
            
        case 6:
            
            //access Rest Id to show it's meals via api
            let restaurantsData = ArraysModels.restFish[indexPath.row]
            //go to MealsListVC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC
            
            mealListVC.restaurantId   = restaurantsData.id
            mealListVC.restaurantName = restaurantsData.name
            mealListVC.restaurant     = restaurantsData
            navigationController?.show(mealListVC, sender: self)
            
        case 7:
            
            //access Rest Id to show it's meals via api
            let restaurantsData = ArraysModels.restDesserts[indexPath.row]
            //go to MealsListVC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC
            
            mealListVC.restaurantId   = restaurantsData.id
            mealListVC.restaurantName = restaurantsData.name
            mealListVC.restaurant     = restaurantsData
            navigationController?.show(mealListVC, sender: self)
            
        default:
            print("error")
        }
    }
    
}
   

extension RestaurantsVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filterdRestaurants      = ArraysModels.restaurants
            collectionView.reloadData()
            return
        }
        filterdRestaurants = ArraysModels.restaurants.filter({ restaurants -> Bool in
       
            (restaurants.name.lowercased().contains(searchText.lowercased()))
        })
        
        //Scroll To Restaurants Section To Make Search Result Visible To User
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 1), at: .centeredVertically, animated: true)
        collectionView.reloadData()
    }
}
extension UIButton{

    func setImageBackgroundColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.backgroundColor = color
//        self.tintColor = color
    }

}
extension UIButton{

    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
//        self.tintColor = color
    }

}
