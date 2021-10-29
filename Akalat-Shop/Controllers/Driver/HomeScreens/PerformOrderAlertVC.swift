//
//  PerformOrderAlertVC.swift
//  Akalat Shop
//
//  Created by Macbook on 06/09/2021.
//

import UIKit

class PerformOrderAlertVC: UIViewController {
    
    var orderId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func pickOrder() {
        
        NetworkManager.pickOrder(orderId: self.orderId ?? 0) { (json: [String : Any]?) in
            if let status = json?["status"] as? String {
                switch status {
                
                case "failed":
                    
                    Helper().showAlert(title: "Error !", message: json?["message"] as? String ?? "Error Try Again, Later", in: self)
                    
                    self.dismiss(animated: true, completion: {
                        appDelegate.infoView(message: json?["message"] as! String, color: colorSmoothRed)
                       
                    })
                    
                default:
                    let alertView = UIAlertController(title: "Success!", message: "Order Has Been Picked Successfully 👌🏻", preferredStyle: .alert)
                    self.performSegue(withIdentifier: "CurrentDelivery", sender: self)
                    let actionButton = UIAlertAction(title: "Keep Delievring Your Order Now 🎉", style: .default,handler: { (ok) in 
                        appDelegate.infoView(message: "Order Has Been Picked Successfully 👌🏻", color: colorLightGreen)
                    })
                    alertView.addAction(actionButton)
                    self.present(alertView, animated: true, completion: nil)
                }
            }
        }
    }
   
    //Go Back To OrdersVC
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    //Go To Map To Deliver The Order
    @IBAction func okButtonTapped(_ sender: Any) {
        
        pickOrder()

    }
    
}
