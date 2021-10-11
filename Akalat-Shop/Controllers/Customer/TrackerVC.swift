//
//  TrackerVC.swift
//  EgyStore
//
//  Created by Macbook on 6/14/21.
//  Copyright © 2021 Abdallah Eslah. All rights reserved.
//

import UIKit
import MapKit

class TrackerVC: UIViewController {

    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    
    //For Showing Customer Address
    var destination: MKPlacemark?
    
    //For Showing Restaurant Address
    var source     : MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TrackerTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackerTableViewCell")
        configureMenu()
        fetchLatestOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderLocationStatus()
    }
    
    func configureMenu() {
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func fetchLatestOrders() {
        NetworkManager.getLatestOrders { (orderDetails, error) in
            if error == nil {
                DispatchQueue.main.async {
                  
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
    
    func orderLocationStatus() {
        NetworkManager.getOrderStatus { order, error in
            if error == nil {
                DispatchQueue.main.async{
                    if order?.status == nil {
                        self.deliveryStatusLabel.text = "You Have No Orders Yet !"
                    } else {
                        self.deliveryStatusLabel.text = order?.status?.uppercased()
                    }
                    let fromRestaurantAddress = order?.restaurant.address.uppercased()
                    let toCustomerAddress     = order?.address
                    self.getLocationAddress(fromRestaurantAddress ?? "", "Restaurant", { restaurantAddress in
                        self.source = restaurantAddress
                        self.getLocationAddress(toCustomerAddress ?? "", "You", { customerDestination in
                            self.destination = customerDestination
                            self.getDirections()
                        })
                    })
                }
            } else {
                DispatchQueue.main.async{
                    self.presentGFAlertOnMainThread(title: "Error !", message: error!.rawValue, buttonTitle: "Ok")
                }
            }
        }
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
        
        let orders = ArraysModels.listOrders[indexPath.row]
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
        render.strokeColor = UIColor.blue
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
}
