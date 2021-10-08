//
//  OrdersVC.swift
//  Akalat Driver
//
//  Created by Macbook on 09/07/2021.
//

import UIKit
import JGProgressHUD

class OrdersVC: UITableViewController {

    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMenu()
        getDriverLatestOrders()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        
    }

    func configureMenu() {
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func getDriverLatestOrders() {
        hud.textLabel.text = "Loading..."
        hud.show(in: self.view)
        
        NetworkManager.DriverGetReadyOrders { (orders, error) in
            
            if orders.count == 0 {
                let emptyState = UILabel(frame: self.view.frame.inset(by: .init(top: 60, left: 30, bottom: 100, right: 30)))
                emptyState.text = "Please Wait For Upcoming Orders 🥡. And Refresh Your Feed..!"
                emptyState.font = .boldSystemFont(ofSize: 22)
                emptyState.textAlignment = .center
                emptyState.numberOfLines = 0
                emptyState.textColor = colorSmoothRed
                self.view.addSubview(emptyState)
            }

            self.hud.dismiss()
        
            ArraysModels.driverReadyOrders.removeAll()

            ArraysModels.driverReadyOrders.append(contentsOf: orders)
            
            self.hud.dismiss()
            self.tableView.reloadData()
        }
        self.hud.dismiss()
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
