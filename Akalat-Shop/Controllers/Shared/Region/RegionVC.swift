//
//  RegionVC.swift
//  Akalat Shop
//
//  Created by Macbook on 06/07/2021.
//

import UIKit
import JGProgressHUD

class RegionVC: UIViewController {
   
    @IBOutlet weak var regionTextField: UITextField!
    
    
    //Configure PickerView
    var pickerView = UIPickerView()
    let hud = JGProgressHUD(style: .dark)
    var regions    = ["Fayoum","October"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerViewConfig()
//        fetchRestaurantsAdresses()
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if textField.tag == 1 {
                textField.text = ""
                return false
            }
            return true
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField.tag == 1 {
                textField.text = ""
                return false
            }
            return true
        }
    
    func pickerViewConfig() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 1
        
        regionTextField.inputView = pickerView
        regionTextField.textAlignment = .center
        regionTextField.placeholder = "Select Your Region"
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        if regionTextField.text?.isEmpty == true {
            Helper().showAlert(title: "Region", message: "Please Select Your Region", in: self)
        } else {
        
        let region = regionTextField.text
        UserDefaults.standard.setValue(region, forKey: "region") 
        
        //go to MealsListVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)

//        navigationController?.show(loginVC, sender: self)
        }
        
    }
    
    
}
extension RegionVC: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        regions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        regionTextField.text = regions[row]
        regionTextField.resignFirstResponder()
    }
    
    
    
}
