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

class CheckoutVC: UIViewController {
    
    //Views
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var deliveryView: UIVisualEffectView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var mapView: UIView!
    
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
        configureMenu()
        basketHandling()
        fetchTrayMeals()
        userLocation()
        addressDetails()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deliveryView.addBorder(toSide: UIView.ViewSide.Top, withColor: UIColor.lightGray, andThickness: 1)
        
        map.layer.cornerRadius = 12
        map.clipsToBounds = true
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
            emptyBasketLabel.center = self.view.center
            emptyBasketLabel.textAlignment = NSTextAlignment.center
            emptyBasketLabel.text = "Your Basket Is Empty.Add Your Meals 👋🏻"
            
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
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func addressDetails() {
        self.addressTextfield.addTarget(self, action: #selector(showAddressPopUP), for: .touchDown)
    }

    @objc func showAddressPopUP() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addressVC = storyboard.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC {
            addressVC.AddressProtocol = self
            self.present(addressVC, animated: true)

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
                print("Error", error)
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
        
        if addressTextfield.text!.isEmpty  || phoneTextField.text!.isEmpty{
            
            self.addressTextfield.becomeFirstResponder()
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
                    
                    //Save Data To Defaults
                    UserDefaults.standard.setValue(Tray.currentTray.address, forKey: "address")
                    UserDefaults.standard.setValue(Tray.currentTray.Phone, forKey: "phone")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let trackerVC = storyboard.instantiateViewController(withIdentifier: "TrackerVC") as? TrackerVC {
                        Tray.currentTray.reset()
                        appDelegate.infoView(message: "Congrates! 😃 Your Order Is Being processed 🎉", color: colorLightGreen)
                        self.navigationController?.show(trackerVC, sender: self)
                    }
                }else {
                    print(error!.localizedDescription)
                    Helper().showAlert(title: "Error", message: error!.localizedDescription, in: self)
                }
            }
        }
    }
    
    
}

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
