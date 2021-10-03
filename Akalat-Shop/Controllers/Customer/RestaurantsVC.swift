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


class RestaurantsVC: UITableViewController, UISearchControllerDelegate {

   
    @IBOutlet var headerButtons: [UIButton]!
    
    static var sectionHeaderElementKind = "header"
    
    @IBOutlet weak var headerScrollView: UIScrollView!
    
    
    @IBOutlet weak var mySecCollectionView: UICollectionView!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    let menuButton = UIButton(type: .custom)
    
    // Declare the serachBar In Nav Bar
    let searchBar = UISearchBar()
    
    var filterdRestaurants = [RestaurntsResult]()
    
    var timer: Timer?
    var currentCellIndex = 0
    let animationView = AnimationView(animation: Animation.named("lf30_editor_reir1nit"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        DispatchQueue.main.async { [weak self] in
            self?.startTimer()
        }
        
        configureSearchBar()
//        addNavBarImage()
        
        headerScrollView.delegate = self
        
        mySecCollectionView.delegate = self
        
        mySecCollectionView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "RestaurantsTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantsTableViewCell")

        
        mySecCollectionView.register(UINib(nibName: "CustomRestaurantLayoutCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell")
        
        mySecCollectionView.register(UINib(nibName: "RestaurantsHeaderCollectionReusableView", bundle: nil),forSupplementaryViewOfKind: "header",withReuseIdentifier:"RestaurantsHeaderCollectionReusableView")
        
        fetchRestaurants()
//        fetchAllMeals()
       
        DismissSearchBar()
        
//        mySecCollectionView.isPagingEnabled = true
        mySecCollectionView.collectionViewLayout = createcompositionalLayout()
//        layout.numberOfVisibleItems = 3
        headerScrollView.isDirectionalLockEnabled = true

        
        
        animationView.frame = view.bounds

        // Add animationView as subview
        view.addSubview(animationView)

        // Play the animation
        animationView.play()
        animationView.loopMode = .repeat(3.0)
        animationView.animationSpeed = 1
        
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    @objc func timerAction() {
        
        if currentCellIndex < filterdRestaurants.count  {
            
            mySecCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            currentCellIndex += 1
        }
        else {
            
            mySecCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            currentCellIndex = 0
        }
    }
   
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("FirstViewController will appear")
        navigationItem.hidesSearchBarWhenScrolling = false
        self.tableView.reloadData()
        self.mySecCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("FirstViewController will disappear")
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for button in headerButtons {
            button.layer.cornerRadius = button.frame.width / 2
            button.clipsToBounds = true
        }
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
            return createSecoendSection()
//        case 1:
//            return createSecoendSection()
//        case 2 :
//            return createSecoendSection()
        default:
            return createSecoendSection()
        }
    }
    
    func createSecoendSection() -> NSCollectionLayoutSection {
        let inset: CGFloat = 2.5
        
        //Item
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //Group
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [smallItem])
        
        let horiztanlGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let horiztanlgroup = NSCollectionLayoutGroup.horizontal(layoutSize: horiztanlGroupSize, subitems: [largeItem,verticalgroup])
        
        
        //section
        let section = NSCollectionLayoutSection(group: horiztanlgroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
  
        return section
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentCellIndex = Int(scrollView.contentOffset.x / mySecCollectionView.frame.size.width)
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
    
    
        
    func fetchRestaurants(){
        
        NetworkManager.getRestaurantsList(restaurantAddress: Constants.region ?? "") { restaurants, error in
            if error == nil {
                
                self.animationView.stop()
                self.animationView.removeFromSuperview()
                
                ArraysModels.restaurants.removeAll()
                //            self.filterdRestaurants.removeAll()
                ArraysModels.restaurants.append(contentsOf: restaurants)
                
                self.filterdRestaurants = ArraysModels.restaurants
                
                self.mySecCollectionView.reloadData()
                self.tableView.reloadData()
            } else {
                Helper().showAlert(title: "Error !", message: error!.localizedDescription, in: self)
                self.animationView.stop()
                self.animationView.removeFromSuperview()
            }
            
        }
        
    }
    
    
    // MARK: - <SearchBar>
    fileprivate func configureSearchBar() {
       
        searchBar.placeholder = "Restaurants Search.. "
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
//        navigationItem.searchController = searchBar
        searchBar.delegate = self
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.titleView = searchBar
        
        // accessing childView - textField inside of the searchBar
        let searchBar_textField = searchBar.value(forKey: "searchField") as? UITextField
        searchBar_textField?.textColor = .white
        searchBar_textField?.tintColor = .white
        
        // insert searchBar into navigationBar
        self.navigationItem.titleView = searchBar
        
        //            navigationItem.hidesSearchBarWhenScrolling = false
//        searchBar.hidesNavigationBarDuringPresentation = true
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = nil
        
        
        menuButton.setImage(UIImage (named: "icon_menu_24dp"), for: .normal)
        
        menuButton.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        menuButton.addTarget(self, action: #selector(configureMenu), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: menuButton)
        
        let button2 = UIButton(type: .custom)
        button2.isUserInteractionEnabled = false
        button2.setImage(UIImage (named: "LogoWithoutName"), for: .normal)
        button2.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        //button.addTarget(target, action: nil, for: .touchUpInside)

        let barButtonItem2 = UIBarButtonItem(customView: button2)
        self.navigationItem.leftBarButtonItems = [barButtonItem, barButtonItem2]
        

    }
        
    // MARK: - <Configure Menu>
    @objc func configureMenu() {
        if self.revealViewController() != nil {
//        button.target = self.revealViewController()
            self.revealViewController().revealToggle(self)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    // MARK: - <Logo App In The Center>
    func addNavBarImage(){
        let imageView = UIImageView(image: #imageLiteral(resourceName: "d2baf949-2f8c-47ad-9985-82e2d2105d04-2") )
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        imageView.contentMode = .scaleAspectFill
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 24))
        
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView
    }
    

    
    @IBAction func categoriesAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            if let sandwichesVC = storyboard.instantiateViewController(withIdentifier: "SandwichesVC") as? SandwichesVC {
                navigationController?.show(sandwichesVC, sender: self)
            }
        } else if sender.tag == 1 {
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            if let pizzaVC = storyboard.instantiateViewController(withIdentifier: "PizzaVC") as? PizzaVC {
                navigationController?.show(pizzaVC, sender: self)
            }
        } else if sender.tag == 2 {
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            if let friedChickenVC = storyboard.instantiateViewController(withIdentifier: "FriedChickenVC") as? FriedChickenVC {
                navigationController?.show(friedChickenVC, sender: self)
            }
        } else if sender.tag == 3 {
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            if let grillsVC = storyboard.instantiateViewController(withIdentifier: "GrillsVC") as? GrillsVC {
                navigationController?.show(grillsVC, sender: self)
            }
        } else if sender.tag == 4 {
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            if let fishVC = storyboard.instantiateViewController(withIdentifier: "FishVC") as? FishVC {
                navigationController?.show(fishVC, sender: self)
            }
        } else  {
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            if let dessertsVC = storyboard.instantiateViewController(withIdentifier: "DessertsVC") as? DessertsVC {
                navigationController?.show(dessertsVC, sender: self)
            }
        }
    }
    
        
   
}
    
extension RestaurantsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return filterdRestaurants.count
      

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = self.mySecCollectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "RestaurantsHeaderCollectionReusableView", for: indexPath) as? RestaurantsHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        view.headerLabel.text = indexPath.section == 1 ? "Browse By Catogery" : "Common Choices"
        return view
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let secondCell = mySecCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomRestaurantLayoutCollectionViewCell", for: indexPath) as? CustomRestaurantLayoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //Configure the cell...
        let restaurantsData = filterdRestaurants[indexPath.row]
        secondCell.restaurantName.text = restaurantsData.name
        
        
        if let url = URL(string: restaurantsData.logo) {
            let placeholder = UIImage(named: "contact-bg")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            secondCell.restaurantImage.kf.indicatorType = .activity
            secondCell.restaurantImage.kf.setImage(with: url,placeholder: placeholder,options: options)
            
            
            
        }
        return secondCell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == self.mySecCollectionView {
        //access Rest Id to show it's meals via api
        let restaurantsData = filterdRestaurants[indexPath.row]
        //go to MealsListVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC

        mealListVC.restaurantId   = restaurantsData.id
        mealListVC.restaurantName = restaurantsData.name
        mealListVC.restaurant     = restaurantsData
        navigationController?.show(mealListVC, sender: self)
        }
    }
    
    
    
      
}

extension RestaurantsVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filterdRestaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsTableViewCell") as? RestaurantsTableViewCell else {
            return UITableViewCell()
        }
        let restaurantsData = self.filterdRestaurants[indexPath.row]
        cell.configureCell(restaurant: restaurantsData)
        return cell
    }
           

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //access Rest Id to show it's meals via api
        let restaurantsData = filterdRestaurants[indexPath.row]
        //go to MealsListVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mealListVC = storyboard.instantiateViewController(withIdentifier: "MealListVC") as! MealListVC

        mealListVC.restaurantId   = restaurantsData.id
        mealListVC.restaurantName = restaurantsData.name
        mealListVC.restaurant     = restaurantsData
        navigationController?.show(mealListVC, sender: self)

    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
}

extension RestaurantsVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filterdRestaurants = ArraysModels.restaurants
            tableView.reloadData()
            self.mySecCollectionView.reloadData()
            return
        }
        filterdRestaurants = ArraysModels.restaurants.filter({ restaurants -> Bool in

            (restaurants.name.lowercased().contains(searchText.lowercased()))
        })
        self.tableView.reloadData()
        self.mySecCollectionView.reloadData()
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
