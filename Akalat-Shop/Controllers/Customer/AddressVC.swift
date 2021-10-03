//
//  AddressVC.swift
//  Akalat Shop
//
//  Created by Macbook on 7/5/21.
//

import UIKit

protocol AddressProtocol {
    
    func addressCity (name: String)
   
    
}

class AddressVC: UIViewController {
    @IBOutlet weak var addressCityTextField: UITextField!
    
    @IBOutlet weak var addressStateTextField: UITextField!
    
    @IBOutlet weak var addressBlockTextField: UITextField!
    
    
    var passedAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGesture()
    }
    
    var AddressProtocol : AddressProtocol?
    
    
    func addTapGesture() {
        
    let tap = UITapGestureRecognizer(target: self, action: #selector(closePopUp))
    tap.numberOfTapsRequired = 1
    view.addGestureRecognizer(tap)
    
    }
    
    @objc func closePopUp() {
        dismiss(animated:true) {
            
            if !self.addressCityTextField.text!.isEmpty || !self.addressStateTextField.text!.isEmpty {
            
            self.AddressProtocol?.addressCity(name: "\(self.addressCityTextField.text!) \(self.addressStateTextField.text!)")
            }
            
        }
        
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated:true) {
            
            self.AddressProtocol?.addressCity(name: "\(self.addressCityTextField.text!) \(self.addressStateTextField.text!)")
           
        }
        
        
    }
    
    
}
