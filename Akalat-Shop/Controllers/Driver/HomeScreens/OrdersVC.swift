//
//  OrdersVC.swift
//  Akalat Driver
//
//  Created by Macbook on 09/07/2021.
//

import UIKit
import JGProgressHUD

class OrdersVC: UITableViewController, SWRevealViewControllerDelegate {

    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDriverLatestOrders()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMenu()
        tableView.reloadData()
    }
    
    

    func configureMenu() {
        if AppLocalization.currentAppleLanguage() == "ar" {
            if self.revealViewController() != nil {
                let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                let sidemenuViewController = storyboard.instantiateViewController(withIdentifier: "DriverMenuVC") as! DriverMenuVC
                revealViewController().rightViewController = sidemenuViewController
                revealViewController().delegate = self
                self.revealViewController().rightViewRevealWidth = self.view.frame.width * 0.8
                menuBarButton.target = self.revealViewController()
                menuBarButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
        } else {
            if self.revealViewController() != nil {
                menuBarButton.target = self.revealViewController()
                menuBarButton.action = #selector(revealViewController().revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
    }
    
    func getDriverLatestOrders() {
        
        NetworkManager.DriverGetReadyOrders { (orders, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.hud.dismiss()
                    ArraysModels.driverReadyOrders.removeAll()
                    ArraysModels.driverReadyOrders.append(contentsOf: orders)
                    if orders.count == 0 {
                        let emptyState = UILabel(frame: self.view.frame.inset(by: .init(top: 60, left: 30, bottom: 100, right: 30)))
                        emptyState.text = "Please Wait For Upcoming Orders 🥡. And Refresh Your Feed..☑️"
                        emptyState.font = .boldSystemFont(ofSize: 22)
                        emptyState.textAlignment = .center
                        emptyState.numberOfLines = 0
                        emptyState.textColor = colorSmoothRed
                        self.view.addSubview(emptyState)
                    } 
                    self.tableView.reloadData()
                }
            }else {
                self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
                self.hud.dismiss()
            }
        }
    }
}
        
       

extension OrdersVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArraysModels.driverReadyOrders.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as? OrdersTableViewCell else {
            return UITableViewCell()
        }
        let OrdersData = ArraysModels.driverReadyOrders[indexPath.row]
        cell.configureCell(order: OrdersData)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //When I Tap The Cell I Take The Id Of It To The Order Func
        let driversOrder = ArraysModels.driverReadyOrders[indexPath.row]
        
        guard let confirmOrderVC = UIStoryboard(name: "DriverMain", bundle: nil).instantiateViewController(withIdentifier: "PerformOrderAlertVC") as? PerformOrderAlertVC else {
            return
        }
        confirmOrderVC.orderId = driversOrder.id
        
        navigationController?.show(confirmOrderVC, sender: self)
        
    }
    
}
