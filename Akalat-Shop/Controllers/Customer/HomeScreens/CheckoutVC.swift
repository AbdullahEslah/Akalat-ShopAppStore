//
//  CheckoutVC.swift
//  EgyStore
//
//  Created by Macbook on 6/12/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CheckoutVC: UIViewController, SWRevealViewControllerDelegate {
    
    //Views
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var deliveryView: UIVisualEffectView!
    @IBOutlet weak var addressView : UIView!
    @IBOutlet weak var mapView     : UIView!
    
    //Objects
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    //Variables
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CheckoutDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutDetailsTableViewCell")
        tableView.tableFooterView = UIView()
        basketHandling()
        fetchTrayMeals()
        userLocation()
        addressDetails()
//        addressTextfield.keyboardType = UIKeyboardType.asciiCapableNumberPad
//        addressTextfield.text!.convertedDigitsToLocale(Locale(identifier: "EN")) /* 12345 */
        addressTextfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deliveryView.addBorder(toSide: UIView.ViewSide.Top, withColor: UIColor.lightGray, andThickness: 1)
        
        map.layer.cornerRadius = 12
        map.clipsToBounds = true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let rawString = string
//         let range = rawString.rangeOfCharacter(from: .whitespaces)
//        if ((textField.text?.count)! == 0 && range  != nil)
//        || ((textField.text?.count)! > 0 && textField.text?.last  == " " && range != nil)  {
//            return false
//        }
//    return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField.keyboardType == .numberPad && string != "" {
                let numberStr: String = string
                let formatter: NumberFormatter = NumberFormatter()
                formatter.locale = Locale(identifier: "EN")
                if let final = formatter.number(from: numberStr) {
                    textField.text =  "\(textField.text ?? "")\(final)"
                }
                    return false
            }
            return true
        }
    
    
    
    func fetchData() {
        if Constants.address != nil {
            addressTextfield.text = Constants.address
        }
        
        if Constants.phone != nil {
            phoneTextField.text   = Constants.phone
        }
    }
    
    func basketHandling() {
        if Tray.currentTray.items.count == 0 {
            //Show A Message
            let emptyBasketLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            emptyBasketLabel.numberOfLines = 0
            emptyBasketLabel.font = UIFont.systemFont(ofSize: 16.0)
            emptyBasketLabel.center = self.view.center
            emptyBasketLabel.textAlignment = NSTextAlignment.center
            emptyBasketLabel.text = "Your Basket Is Empty.  Start Adding Your Meals 👋🏻"
//            let image = UIImage(named: "EmptyBasket")!
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
//            imageView.image = image
//            self.view.addSubview(imageView)
            self.view.addSubview(emptyBasketLabel)
        } else {
            self.tableView.isHidden        = false
            self.totalView.isHidden        = false
            self.addressView.isHidden      = false
            self.placeOrderButton.isHidden = false
            self.mapView.isHidden          = false
            self.deliveryView.isHidden     = false
            
        }
    }
    
    func fetchTrayMeals() {
        guard let delivery = Tray.currentTray.restaurant?.delivery else {
            return
        }
        self.tableView.reloadData()
        self.totalLabel.text = "\(Tray.currentTray.getTotal() + delivery) EG"
        
        if Tray.currentTray.restaurant?.delivery != nil {
            
            self.deliveryLabel.text = "\(Tray.currentTray.restaurant!.delivery) EG"
        }
        
       
    }
    
    func configureMenu() {
        
        
        if AppLocalization.currentAppleLanguage() == "ar" {
            if self.revealViewController() != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sidemenuViewController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                revealViewController().rightViewController = sidemenuViewController
                revealViewController().delegate = self
                self.revealViewController().rightViewRevealWidth = self.view.frame.width * 0.8
                menuButton.target = self.revealViewController()
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
        } else {
            if self.revealViewController() != nil {
                menuButton.target = self.revealViewController()
                menuButton.action = #selector(revealViewController().revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
    }
    
    func addressDetails() {
        self.addressTextfield.addTarget(self, action: #selector(showAddressPopUP), for: .touchDown)
    }

    @objc func showAddressPopUP() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addressVC = storyboard.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC else {
        return
        }
            addressVC.AddressProtocol = self
        
        self.present(addressVC, animated: true)
            let geocoder = CLGeocoder()
            
            guard let location = locationManager.location else {
                return
            }
            geocoder.geocodeAddressString("\(location)") { (placemark, error) in
                if error != nil {
                }
                
                guard let placemark = placemark   else {
                    return
                }
                if placemark.count > 0 {
                    let placemark = placemark[0]
                    
                    guard let thoroughfare = placemark.thoroughfare else {
                        return
                    }
                    print(thoroughfare)
                    guard let locality = placemark.locality else {
                        return
                    }
                    print(locality)
                    guard let adminstrativeArea = placemark.administrativeArea else {
                        return
                    }
                    print(adminstrativeArea)
                    addressVC.currentLocationTextField.text = "\(thoroughfare) \(adminstrativeArea) \(locality)"
                    
//                        print(addressVC.currentLocationTextField.text)
                    
                }
               
            
            
        }
    }
    
    //Show User Location
    func userLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            self.map.showsUserLocation = true
            
            
        }
    }
    
    
    @IBAction func goToUserLocationButton(_ sender: Any) {
        
        let address = addressTextfield.text
        
        let geocoder = CLGeocoder()
        Tray.currentTray.address = address
        
        geocoder.geocodeAddressString(address!) { (placemark, error) in
            if error != nil {
                
            }
  
            
            if let placemark = placemark?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.map.setRegion(region, animated: true)
                self.locationManager?.startUpdatingLocation()
                
                //create A Pin In Map
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                self.map.addAnnotation(dropPin)
            }
        }
        
    }
    
    @IBAction func placeOrderButton(_ sender: Any) {
        
        if addressTextfield.text!.isEmpty || phoneTextField.text!.isEmpty{
            
//            self.addressTextfield.becomeFirstResponder()
            self.view.endEditing(true)
            // red placeholders
            addressTextfield.attributedPlaceholder = NSAttributedString(string: "Type Your Address", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            
            phoneTextField.attributedPlaceholder = NSAttributedString(string: "Type Your Phone Number",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            
            // Showing alert that this field is required.
            
            let alertController = UIAlertController(title: "Missing Info", message: "Please Type All Required Fields !", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                self.addressTextfield.becomeFirstResponder()
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        } else {
            
            Tray.currentTray.address = addressTextfield.text
            Tray.currentTray.Phone   = phoneTextField.text
            
            NetworkManager.createOrder { (error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        
                        //Save Data To Defaults
                        UserDefaults.standard.setValue(Tray.currentTray.address, forKey: "address")
                        UserDefaults.standard.setValue(Tray.currentTray.Phone, forKey: "phone")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let trackerVC = storyboard.instantiateViewController(withIdentifier: "TrackerVC") as? TrackerVC {
                            Tray.currentTray.reset()
                            appDelegate.infoView(message: "Congrates! 😃 Your Order Is Being processed 🎉", color: colorLightGreen)
                            self.navigationController?.show(trackerVC, sender: self)
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self.presentGFAlertOnMainThread(title: "Error !", message: error!.localizedDescription, buttonTitle: "Ok")
                    }
                }
            }
        }
    }
    
    
}

//This Delegate Code is showing and focusing in current location 
extension CheckoutVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
        
    }
}

extension CheckoutVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addressTextfield.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addressTextfield.resignFirstResponder()
    }
}

extension CheckoutVC: AddressProtocol {
    func addressCity(name: String) {
        addressTextfield.text = name
    }
    
}

extension CheckoutVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tray.currentTray.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutDetailsTableViewCell", for: indexPath) as? CheckoutDetailsTableViewCell else {
            return UITableViewCell()
        }
        let trayData = Tray.currentTray.items[indexPath.row]
    
        cell.mealName.text  = trayData.meal.name
        cell.mealCount.text = "\(trayData.qty)"
        cell.mealPrice.text = "\(trayData.meal.price * Float(trayData.qty) )"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale

        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }

        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}
