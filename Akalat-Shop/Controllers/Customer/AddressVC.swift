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

        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let rawString = string
         let range = rawString.rangeOfCharacter(from: .whitespaces)
        if ((textField.text?.count)! == 0 && range  != nil)
        || ((textField.text?.count)! > 0 && textField.text?.last  == " " && range != nil)  {
            return false
        }
    return true
    }
    
    var AddressProtocol : AddressProtocol?
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func DoneButton(_ sender: Any) {
        
        if self.addressCityTextField.text!.isEmpty || self.addressStateTextField.text!.isEmpty || self.addressBlockTextField.text!.isEmpty {
            
            
//                self.addressCityTextField.becomeFirstResponder()
            self.view.endEditing(true)
            // red placeholders
            self.addressCityTextField.attributedPlaceholder = NSAttributedString(string: "Type Your City", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            self.addressStateTextField.attributedPlaceholder = NSAttributedString(string: "Type Your State", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            
            self.addressBlockTextField.attributedPlaceholder = NSAttributedString(string: "Type Your Block / Flat Number",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            
            // Showing alert that this field is required.
            
            let alertController = UIAlertController(title: "Missing Info", message: "Please Type All Required Fields !", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
//                    self.addressTextfield.becomeFirstResponder()
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            dismiss(animated:true) {
                
                self.AddressProtocol?.addressCity(name: "\(self.addressCityTextField.text!) \(self.addressStateTextField.text!)")
                
            }
            
            
        }
        
    }
    
    
}
