//
//  LastOrderVC.swift
//  Akalat-Shop
//
//  Created by Macbook on 05/12/2021.
//

import UIKit
import SkeletonView
import Kingfisher

class LastOrderVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate   = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TrackerTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackerTableViewCell")
        self.tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: .none, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
            fetchLatestOrders()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func fetchLatestOrders() {
        NetworkManager.getOrderDetails { (orderDetails, error) in
            if error == nil {
                DispatchQueue.main.async {
                    
                    if orderDetails.count == 0 {
                        let emptyBasketLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
                        emptyBasketLabel.numberOfLines = 0
                        emptyBasketLabel.font = UIFont.systemFont(ofSize: 16.0)
                        emptyBasketLabel.center = self.view.center
                        emptyBasketLabel.textAlignment = NSTextAlignment.center
                        emptyBasketLabel.text = "You havn't Ordered Yet. Order Yours Now 👋🏻"
                    }
                    
                    ArraysModels.listOrders.removeAll()
                    ArraysModels.listOrders.append(contentsOf: orderDetails)
                    
                    self.tableView.stopSkeletonAnimation()
                    self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self.tableView.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self.tableView.stopSkeletonAnimation()
                    self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }

}


extension LastOrderVC: SkeletonTableViewDataSource,UITableViewDelegate {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TrackerTableViewCell"
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArraysModels.listOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerTableViewCell", for: indexPath) as? TrackerTableViewCell else {
            return UITableViewCell()
        }
        
        let orders               = ArraysModels.listOrders[indexPath.row]
        
        cell.mealCountLabel.text = "\(orders.quantity)"
        cell.mealNameLabel.text  = "\(orders.meal.name)"
        cell.mealPriceLabel.text = "\(Float(orders.sub_total))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
