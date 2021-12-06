//
//  TrackerVC.swift
//  EgyStore
//
//  Created by Macbook on 6/14/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit
import MapKit

class TrackerVC: UIViewController, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    //For Showing Customer Location
    var destination: MKPlacemark?
    
    //For Showing Restaurant Location
    var source     : MKPlacemark?
    
    //For Showing Driver Location
    var driverPin: MKPointAnnotation!
    
    //For Getting Driver Location Every Second
    var timer   = Timer()
    
    var latestOrders : Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TrackerTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackerTableViewCell")
        fetchLatestOrders()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMenu()
        orderLocationStatus()
        fetchDeliveryOrders()
    }
    
    func configureMenu() {
        if AppLocalization.currentAppleLanguage() == "ar" {
            if self.revealViewController() != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sidemenuViewController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
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
    
    func fetchLatestOrders() {
        NetworkManager.getOrderDetails { (orderDetails, error) in
            if error == nil {
                DispatchQueue.main.async {
//                    orderDetails?.restaurant.delivery
                    ArraysModels.listOrders.removeAll()
                    ArraysModels.listOrders.append(contentsOf: orderDetails)
                    self.tableView.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    func fetchDeliveryOrders() {
        NetworkManager.getLatestOrders { (orderDetails, error) in
            if error == nil {
                DispatchQueue.main.async {
                    
                    guard let orders = orderDetails else {
                        return
                    }
                    if orders.total == nil {
                        self.deliveryPriceLabel.isHidden = true
                        self.totalLabel.isHidden = true
                    } else {
                      //Usage Of Localized Words
                        let orderDeliveryPrice = NSLocalizedString("deliveryPriceKey", comment: "")
                    
                    self.deliveryPriceLabel.text = "\(orderDeliveryPrice):   \(orders.restaurant.delivery ?? 0) LE"
                    }
                    
                    let total: Double = orders.total ?? 0
                    let delivery: Double = orders.restaurant.delivery ?? 0
                    let all = total + delivery

                    let orderTotal = NSLocalizedString("totalKey", comment: "")
                    self.totalLabel.text = "\(orderTotal)      :   \(all) LE"
                    self.tableView.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    func orderLocationStatus() {
        
        NetworkManager.getOrderStatus { order, error in
            if error == nil {
                DispatchQueue.main.async{
                    if order?.status == nil {
                        self.deliveryStatusLabel.text = "You Have No Orders Yet !"
                    } else {
                        self.deliveryStatusLabel.text = order?.status?.uppercased()
                        self.tableView.reloadData()
                        
                        let fromRestaurantAddress = order?.restaurant.address_details?.uppercased()
                        let toCustomerAddress     = order?.address
                        self.getLocationAddress(fromRestaurantAddress ?? "", "RESTAURANT", { restaurantAddress in
                            self.source = restaurantAddress
                            self.getLocationAddress(toCustomerAddress ?? "", "YOU", { customerDestination in
                                self.destination = customerDestination
                                self.getDirections()
                            })
                        })
                        
                        //see the driver location if the driver picked the order and not delivered yet
                        if order?.status == "On the way" {
                            self.getDriverLocationEveryOneSecond()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async{
                    self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    func getDriverLocationEveryOneSecond() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getDriverLocation), userInfo: nil, repeats: true)
    }
    
    @objc func getDriverLocation() {
        
        NetworkManager.GetDriverLocation { (latAndLong, error) in
            if error == nil {
                DispatchQueue.main.async{
                     
                    //To prevent run the server every second if we havn't any orders
                    if let location = latAndLong?.location  {
                        
//                        self.deliveryStatusLabel.text = "ON THE WAY"
                        
                        //Getting Lat And Long From Response before and after the comma
                        let split   = location.components(separatedBy: ",")
                        let lat     = split[0]
                        let long    = split[1]
                        
                        //Putting the lat and long degrees in coordinate variable
                        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(long)!)
                        
                        // Create pin annotation for Driver
                        if self.driverPin != nil {
                            self.driverPin.coordinate = coordinate
                        } else {
                            self.driverPin = MKPointAnnotation()
                            self.driverPin.coordinate = coordinate
                            self.map.addAnnotation(self.driverPin)
                            self.driverPin.title = "DRIVER"
                        }
                        // Reset zoom rect to cover 3 locations
                        self.autoZoomDriverLocation()
                    } else { 
                        //To Stop Running The Timer
                        self.timer.invalidate()
                    }
                }
            }
        }
    }
    
    // Reset zoom rect to cover 3 locations
     func autoZoomDriverLocation() {
        
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
extension TrackerVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArraysModels.listOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerTableViewCell", for: indexPath) as? TrackerTableViewCell else {
            return UITableViewCell()
        }
        
        let orders       = ArraysModels.listOrders[indexPath.row]
        
        cell.mealCountLabel.text = "\(orders.quantity)"
        cell.mealNameLabel.text  = "\(orders.meal.name)"
        cell.mealPriceLabel.text = "\(Float(orders.sub_total))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

extension TrackerVC: MKMapViewDelegate {
    
    //Delegate Func Of MKMapViewDelegate (Create A Line Betwween Two Locations)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor(named:"MainColor")
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
    
    // #3 - Get direction and zoom to address
    func getDirections() {
        
        let request = MKDirections.Request()
        request.source = MKMapItem.init(placemark: source!)
        request.destination = MKMapItem.init(placemark: destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            
            if error != nil {
                print("Error: ", error)
            } else {
                // Show route
                self.showRoute(response: response!)
            }
        }
        
    }
    
    // #4 - Show route between locations and make a visible zoom
    func showRoute(response: MKDirections.Response) {
        
        for route in response.routes {
            self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
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
    
    // Customize Annotation (Pin) With Image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        //Steps For Creating Annotaion 1
        let  annotationId  = "MyPin"
        var  annotationView: MKAnnotationView?
        
        // Step 2 (End)
        if let dequeueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId)  {
            
            annotationView = dequeueAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
        }
        
        // And Here If We Have Annotation And It's title called Driver put annotation With Image Driver... and so on
        if let annotationView = annotationView, let name = annotation.title!{
            
            switch name {
            case "DRIVER":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "LogoWithoutName")
                
                
            case "YOU":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_customer")
                
                
            case "RESTAURANT":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_restaurant")
                
            
            default:
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "LogoWithoutName")
            }
        }
        return annotationView
    }
}
