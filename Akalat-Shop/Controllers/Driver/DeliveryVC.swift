//
//  DeliveryVC.swift
//  Akalat Driver
//
//  Created by Macbook on 09/07/2021.
//

import UIKit
import Lottie
import Kingfisher
import MapKit

class DeliveryVC: UIViewController,UIActionSheetDelegate {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var customerAva: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customerPhoneNumber: UIButton!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var completeOrderButton: RoundedButton!
    @IBOutlet weak var customerInfoView: UIView!
    @IBOutlet weak var map: MKMapView!
    
    let animationView  = AnimationView(animation: Animation.named("39587-delivery-man"))
    
    var orderId        : Int?
    
    var destination    : MKPlacemark?
    var source         : MKPlacemark?
    
    var locationManager: CLLocationManager!
    var driverPin      : MKPointAnnotation!
    var lastLocation   : CLLocationCoordinate2D!
    
    var timer          = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenu()
        userLocation()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        
        animationView.frame = view.bounds

        // Add animationView as subview
        view.addSubview(animationView)

        // Play the animation
        animationView.play()
        animationView.loopMode = .repeat(3.0)
        animationView.animationSpeed = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customerInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customerAva.layer.borderColor = UIColor(named: "DarkColor")?.cgColor
        customerAva.layer.borderWidth = 1.0
        customerAva.clipsToBounds = true
        customerAva.layer.cornerRadius = customerAva.frame.width / 2
    }
    
    func configureMenu() {
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //Show Driver Location
    func userLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager = CLLocationManager()
            locationManager.delegate   = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.map.showsUserLocation = false
            
        }
    }
    
    func customerInfo() {
        
        NetworkManager.DriverGetLatestOrders { orderDetails, error  in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.animationView.stop()
                    self.animationView.removeFromSuperview()
                    
                    if orderDetails?.status == "On the way" {
                        
                        //If Driver Picked Any Orders So Get His Location Every One Second To Prevent Load On Server
//                        self.updateLocationEveryOneSecond()
                        
                        self.orderId = orderDetails?.id
                        let from = orderDetails?.address
                        let to = orderDetails?.restaurant.address
                        
                        self.customerAddress.text = from
                        let customerName          = orderDetails?.customer.name
                        self.nameLabel.text       = customerName
                        let customerPhone         = orderDetails?.phone_number
                        self.customerPhoneNumber.setTitle(customerPhone, for: .normal)
                        
                        if let url = URL(string: orderDetails?.customer.avatar ?? "") {
                            let placeholder = UIImage(named: "LogoWithoutName")
                            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                            self.customerAva.kf.indicatorType = .activity
                            self.customerAva.kf.setImage(with: url,placeholder: placeholder,options: options)
                            
                            self.getLocationAddress(from ?? "", "Customer", { restaurantAddress in
                                self.source = restaurantAddress
                                self.getLocationAddress(to ?? "", "Restaurant", { customerDestination in
                                    self.destination = customerDestination
                                })
                            })
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.animationView.stop()
                            self.animationView.removeFromSuperview()
                            self.map.isHidden = true
                            self.customerInfoView.isHidden = true
                            self.completeOrderButton.isHidden = true
                            self.customerPhoneNumber.isEnabled = false
                            
                            let emptyState = UILabel(frame: self.view.frame.inset(by: .init(top: 60, left: 30, bottom: 100, right: 30)))
                            emptyState.text = "You Don't Have Any Orders To Be Delivered !"
                            emptyState.font = .boldSystemFont(ofSize: 22)
                            emptyState.textAlignment = .center
                            emptyState.numberOfLines = 0
                            emptyState.textColor = colorSmoothRed
                            self.view.addSubview(emptyState)
                        }
                    }
                }
            } else {

            }
        }
    }
    
//    func updateLocationEveryOneSecond() {
        
//    }
    
    @objc func updateLocation() {
        
        //To Prevent Running The Server Evry Second
        guard let location = self.lastLocation else {
            return
        }
        
        NetworkManager.updateDriverLocation(location: self.lastLocation) { (data) in
            //To Check The Request Every One Second
            print(data)
        }
    }
    
    @IBAction func callCustomerButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Call Customer!", message: "Ask Customer For Address", preferredStyle: .alert) // 1
        let firstAction = UIAlertAction(title: "Call", style: .default) { (alert: UIAlertAction!) -> Void in
            
            if let phoneCallURL:URL = URL(string: "tel:\(self.customerPhoneNumber.title(for: .normal) ?? "")" ) {
                if (UIApplication.shared.canOpenURL(phoneCallURL)) {
                    UIApplication.shared.open(phoneCallURL)
                }
            }
        } // 2
        
        
        let secondAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        } // 3
        
        alert.addAction(firstAction) // 4
        alert.addAction(secondAction) // 5
        present(alert, animated: true, completion:nil) // 6
        
    }
    @IBAction func completeOrder(_ sender: Any) {
        
        let alertView = UIAlertController(title: "Comlete Order!", message: "Are You Want To Complete Order Now ? ", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actionButton = UIAlertAction(title: "Ok 🎉", style: .default,handler: { (ok) in
            
            NetworkManager.DriverCompleteTheOrder(orderId: self.orderId!) { (data) in
//                if error == nil {
                    
                    DispatchQueue.main.async {
                        print(data)
                        //Stop Updating Driver Location
                        self.locationManager.stopUpdatingLocation()
                        self.timer.invalidate()
                        
                        self.performSegue(withIdentifier: "ReadyOrders", sender: self)
                       
                        appDelegate.infoView(message: "Order Has Been Completed Successfully 👌🏻", color: colorLightGreen)
                    }
                    
//                } else {
                    
//                    DispatchQueue.main.async {
//                        appDelegate.infoView(message: error!.localizedDescription, color: colorSmoothRed)
//                        print(error)
//                    }
                
            }
        })
        alertView.addAction(cancelButton)
        alertView.addAction(actionButton)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    
    
}

extension DeliveryVC: MKMapViewDelegate {
    
    //Delegate Func Of MKMapViewDelegate (Create A Line Betwween Two Locations)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = colorLightGreen
        render.lineWidth = 5.0
        
        return render
    }
    
    //Convert The Address To A Location On The Map
    func getLocationAddress(_ address: String,_ title: String,_ completion: @escaping (MKPlacemark) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemark, error) in
            if error != nil {
                print("Error", error)
            }
            if let placemark = placemark?.first {
                
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
               
                //create A Pin In Map
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                
                self.map.addAnnotation(dropPin)
                completion(MKPlacemark.init(placemark: placemark))
            }
        }
    }

    
}

//This Delegate Code is showing and focusing in showing all view of driver,customer and restaurant locations
extension DeliveryVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        self.lastLocation = location.coordinate
        
        
        //If driverAnnotation is not nil assign it's coordinate (lat,long) to the last location of the driver to get it's points in map
        if driverPin != nil {
            driverPin.coordinate = self.lastLocation
        } else {
            // Create pin annotation for Driver
            driverPin = MKPointAnnotation()
            driverPin.coordinate = self.lastLocation
            self.map.addAnnotation(driverPin)
        }
        
        // Reset zoom rect to cover 3 locations
        var zoomRect = MKMapRect.null
        for annotation in self.map.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }

        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = zoomRect.insetBy(dx: insetWidth, dy: insetHeight)

        self.map.setVisibleMapRect(insetRect, animated: true)
    }
}
