//
//  NetworkManager.swift
//  Akalat Shop
//
//  Created by Macbook on 6/18/21.
//

import Foundation
import FBSDKLoginKit
import Alamofire
import GoogleSignIn
<<<<<<< HEAD
import AuthenticationServices
import CoreLocation
=======
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
class NetworkManager {
    
    static var shared = NetworkManager()
    
<<<<<<< HEAD
    static var authorization: ASAuthorization?
    
=======
     
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    
    struct Auth {
        
        static var accessToken       = ""
<<<<<<< HEAD
        static var appleAcccessToken = ""
        static var refreshToken      = ""
        //        static var googleUser       : GIDAuthentication?
        //        static var googleToken      = googleUser?.accessToken
        static var expired           = Date()
        static let clientID          = "v4nB5Ne1YmKYl0LRZ1uj8Z6XEKsaCNrvFpkTRyLN"
        //var googleSignIn = GIDSignIn.sharedInstance.currentUser?.authentication.accessToken
        //        static let signInConfig     = GIDConfiguration.init(clientID: "970857005723-dnkkonoefpeh9cl2jod5crg1ckfmg1h3.apps.googleusercontent.com")
=======
        static var refreshToken      = ""
//        static var googleUser       : GIDAuthentication?
//        static var googleToken      = googleUser?.accessToken
        static var expired           = Date()
        static let clientID          = "v4nB5Ne1YmKYl0LRZ1uj8Z6XEKsaCNrvFpkTRyLN"
        //var googleSignIn = GIDSignIn.sharedInstance.currentUser?.authentication.accessToken
//        static let signInConfig     = GIDConfiguration.init(clientID: "970857005723-dnkkonoefpeh9cl2jod5crg1ckfmg1h3.apps.googleusercontent.com")
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        static let clientSecret      = "4nrs24A27XejXcuH5jrBKFwg1d9PhcaGkPnWj4Uy7YpWVZ5EnIGrqh6OJOYG28svx93D9wS29QdxmGW3HS1N5MdSbHOuMuS6Q8qWI3VpQWvUUrCI8x8ECytr2FP4jG2G"
        
        static let userTypeCustomer  = "customer"
        static let userTypeDriver    = "driver"
    }
<<<<<<< HEAD
    
=======

>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    
    enum EndPoints {
        
        static let base = "http://www.akalatshop.com"
        
        
        //App-Auth Facebook
        case socialAuthLogin
        case socialAuthLogout
        case socialRefreshToken
        
        //Customer App
        case restaurantsList
<<<<<<< HEAD
=======
        case restaurantsCategory
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        case restaurantsMeals
        case allMeals
        case makeAnOrder
        case latestOrders
<<<<<<< HEAD
        case getDriverLocation
        
        //Customer Restaurants Categories
        case restaurantsCategory
=======
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        
        //Driver App
        case driverReadyOrders
        case driverPickingOrder
        case driverLatestOrders
<<<<<<< HEAD
        case driverUpdateLocation
        case driverCompleteOrder
        case driverRevenue
=======
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        
        var stringValue: String {
            
            switch self {
            
            case .socialAuthLogin:
                return EndPoints.base + "/api/social/convert-token/"
                
            case .socialAuthLogout:
                return EndPoints.base + "/api/social/revoke-token/"
                
            case .socialRefreshToken:
                return EndPoints.base + "/api/social/token/"
                
            case .restaurantsList:
                return EndPoints.base + "/api/customer/restaurants/"
                
            case .restaurantsCategory:
                return EndPoints.base + "/api/customer/restaurants/Fayoum/"
                
            case .restaurantsMeals:
                return EndPoints.base + "/api/customer/meals/"
                
            case .allMeals:
                return EndPoints.base + "/api/customer/meals"
                
            case .makeAnOrder:
                return EndPoints.base + "/api/customer/order/add"
                
            case .latestOrders:
                return EndPoints.base + "/api/customer/order/latest?"
                
<<<<<<< HEAD
            case .getDriverLocation:
                return EndPoints.base + "/api/customer/driver/location/?"
                
=======
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
            //Driver
            case .driverReadyOrders:
                return EndPoints.base + "/api/driver/orders/ready/"
                
            case .driverPickingOrder:
                return EndPoints.base + "/api/driver/order/pick/"
                
            case .driverLatestOrders:
                return EndPoints.base + "/api/driver/order/latest?"
<<<<<<< HEAD
                
            case .driverUpdateLocation:
                return EndPoints.base + "/api/driver/location/update/"
                
            case .driverCompleteOrder:
                return EndPoints.base + "/api/driver/order/complete/"
                
            case .driverRevenue:
                return EndPoints.base + "/api/driver/revenue?"
                
=======
               
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
            }
        }
        
        
<<<<<<< HEAD
=======
        
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
   
    //Generic Get Request We Usually don't pass parameters like post we put it in the url
<<<<<<< HEAD
    class func taskForGETRequest<ResponseType:Decodable>(url:URL, responseType: ResponseType.Type,completion: @escaping (ResponseType?, GFError?) -> Void ){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(nil,.UnAbleToComplete)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil,.UnAbleToComplete)
                return
            }
            
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, .invalidData)
=======
    class func taskForGETRequest<ResponseType:Decodable>(url:URL, responseType: ResponseType.Type,completion: @escaping (ResponseType?, Error?) -> Void ){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
<<<<<<< HEAD
                    completion(nil, .invalidData)
=======
                    completion(nil, error)
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
                }
            }
        }
        task.resume()
<<<<<<< HEAD
        
    }
    
    //Generic POST Request We Usually pass parameters so we used body
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, GFError?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(nil,.UnAbleToComplete)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil,.UnAbleToComplete)
                return
            }
            
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, .invalidData)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, .invalidData)
                }
            }
        }
        task.resume()
    }
    
    
    class func secondTaskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
=======
    
    }
    
    //Generic POST Request We Usually pass parameters so we used body
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
<<<<<<< HEAD
            if let _ = error {
                completion(nil,error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil,error)
                return
            }
            
            
=======
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
<<<<<<< HEAD
    /* --------------------------------- Auth ---------------------------------  */
    class func fbLogin(userType: String, completion: @escaping (Bool, GFError?)  -> Void) {
        
=======
    
        

    
    /* --------------------------------- Auth ---------------------------------  */
    class func fbLogin(userType: String, completion: @escaping (Bool, Error?)  -> Void) {

                
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        let body = LoginConvertToken(grant_type: "convert_token", backend: "facebook", user_type: userType, client_id: Auth.clientID, client_secret: Auth.clientSecret,token: AccessToken.current!.tokenString)
        taskForPOSTRequest(url: EndPoints.socialAuthLogin.url, responseType: LoginConvertTokenResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.accessToken = response.access_token
                Auth.refreshToken = response.refresh_token
                Auth.expired = Date().addingTimeInterval(TimeInterval(response.expires_in))
                completion(true, nil)
                print(response)
            } else {
<<<<<<< HEAD
                completion(false, .invalidResponse)
            }
        }
    }
    
    
    
    
    // If App Launched Before
    class func appleIDLogin(userType: String, completion: @escaping (Bool, GFError?)  -> Void) {
        
        guard let token = UserDefaults.standard.value(forKey: "appleIdentityToken") as? String else {
            return
        }
        
        let body = AppleIDLogin(grant_type: "convert_token", backend: "apple-id", user_type: userType, client_id: Auth.clientID, client_secret: Auth.clientSecret,token: token)
        taskForPOSTRequest(url: EndPoints.socialAuthLogin.url, responseType: AppleIDLoginResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.accessToken = response.access_token
                Auth.refreshToken = response.refresh_token
                Auth.expired = Date().addingTimeInterval(TimeInterval(response.expires_in))
                completion(true, nil)
                print(response)
            } else {
                completion(false, .invalidResponse)
=======
                completion(false, error)
                print(error!.localizedDescription)
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
            }
        }
    }
    
<<<<<<< HEAD
    
    class func googleLogin(userType: String, completion: @escaping (Bool, GFError?)  -> Void) {
        
        guard let token = GIDSignIn.sharedInstance.currentUser?.authentication.accessToken else {
=======
    class func googleLogin(userType: String, completion: @escaping (Bool, Error?)  -> Void) {

        guard let token = GIDSignIn.sharedInstance().currentUser?.authentication.accessToken else {
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
            return
        }
        
        let body = GoogleLoginConvertToken(grant_type: "convert_token", backend: "google-oauth2", user_type: userType, client_id: Auth.clientID, client_secret: Auth.clientSecret, token:token)
        taskForPOSTRequest(url: EndPoints.socialAuthLogin.url, responseType: GoogleLoginConvertTokenResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.accessToken = response.access_token
                Auth.refreshToken = response.refresh_token
                Auth.expired = Date().addingTimeInterval(TimeInterval(response.expires_in))
                completion(true, nil)
                print(response)
            } else {
<<<<<<< HEAD
                completion(false, .invalidResponse)
=======
                completion(false, error)
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
                print(error!.localizedDescription)
            }
        }
    }
    
    
    class func logout( completion: @escaping (Error?)  -> Void) {
        
        let body : [String: Any] = ["client_id": Auth.clientID,
                                    "client_secret":Auth.clientSecret,
                                    "token":Auth.accessToken ]

        Alamofire.request(EndPoints.socialAuthLogout.url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
            switch response.result {
            
            case .success(_):
                completion(nil)
                break
            case .failure(let error as Error?):
                completion(error)
                print(error!)
                break
            }
        }
    }
    
    //Refresh Token
    class func refreshToken( completion: @escaping (Bool, Error?)  -> Void) {
        
        let body = RefreshToken(grant_type: "refresh_token", client_id: Auth.clientID, client_secret: Auth.clientSecret, refresh_token: Auth.refreshToken)
        
        //if refresh token we have is smaller than our time now then make this request to get a new access_token , refreshToken, and expires_in time to save it again and compare
        if Date() > Auth.expired {
            
            taskForPOSTRequest(url: EndPoints.socialRefreshToken.url, responseType: RefreshTokenResponse.self, body: body) { (response, error) in
                if let response = response {
                    Auth.accessToken = response.access_token
                    Auth.refreshToken = response.refresh_token
                    Auth.expired = Date().addingTimeInterval(TimeInterval(response.expires_in))
                    completion(true, nil)
                    print(response)
                } else {
                    completion(false, error)
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    //Use generic request to get AppLists from ArrayList Model (GET)
<<<<<<< HEAD
    class func getRestaurantsList(restaurantAddress:String,completion: @escaping ([RestaurntsResult], GFError?) -> Void) {
=======
    class func getRestaurantsList(restaurantAddress:String,completion: @escaping ([RestaurntsResult], Error?) -> Void) {
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        let endPoints = EndPoints.restaurantsList.stringValue + "\(restaurantAddress)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        
<<<<<<< HEAD
        //responseType -> the main model
        taskForGETRequest(url:newUrl , responseType: RestaurantsList.self) { (response, error) in
            if let response = response  {
                //result -> is the [restaurants]
                completion(response.restaurants,nil)
            } else {
                completion([],.UnAbleToComplete)
                print(error!.localizedDescription)
                
                
            }
        }
        
    }
    
    
    class func getRestaurantsCategories(restaurantCategory:String,completion: @escaping ([RestaurntsResult], GFError?) -> Void) {
=======
//        refreshToken { success, error in
            
//            if error == nil {
                //responseType -> the main model
                taskForGETRequest(url:newUrl , responseType: RestaurantsList.self) { (response, error) in
                    if let response = response  {
                        //result -> is the [restaurants]
                        completion(response.restaurants,nil)
                    } else {
                        completion([],error)
                        print(error!.localizedDescription)
                        
                        
                    }
                }
//            }else {
//                print(error?.localizedDescription)
//            }
//        }
    }
    
    
    class func getRestaurantsCategories(restaurantCategory:String,completion: @escaping ([RestaurntsResult], Error?) -> Void) {
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        let endPoints = EndPoints.restaurantsCategory.stringValue + "\(restaurantCategory)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
<<<<<<< HEAD
        //responseType -> the main model
        taskForGETRequest(url:newUrl , responseType: RestaurantsList.self) { (response, error) in
            if let response = response  {
                //result -> is the [restaurants]
                completion(response.restaurants,nil)
            } else {
                completion([],.UnAbleToComplete)
                print(error!.localizedDescription)
            }
        }
=======
        
//        refreshToken { success, error in
//            if error == nil {
                //responseType -> the main model
                taskForGETRequest(url:newUrl , responseType: RestaurantsList.self) { (response, error) in
                    if let response = response  {
                        //result -> is the [restaurants]
                        completion(response.restaurants,nil)
                    } else {
                        completion([],error)
                        print(error!.localizedDescription)
                    }
                }
//            }else {
//                print(error?.localizedDescription)
//            }
//        }
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    }
    
    
    //use generic request to get AppLists from ArrayList Model (GET)
<<<<<<< HEAD
    class func getMealsList(restaurantId:Int ,completion: @escaping ([MealsResult], GFError?) -> Void) {
=======
    class func getMealsList(restaurantId:Int ,completion: @escaping ([MealsResult], Error?) -> Void) {
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        
        let endPoints = EndPoints.restaurantsMeals.stringValue + "\(restaurantId)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
<<<<<<< HEAD
        //responseType -> the main model
        taskForGETRequest(url:newUrl , responseType: MealsList.self) { (response, error) in
            if let response = response  {
                //result -> is the [meals]
                completion(response.meals,nil)
            } else {
                completion([],.UnAbleToComplete)
            }
        }
    }
    
    
    class func getAllMealsList(completion: @escaping ([MealsResult], GFError?) -> Void) {
        
        let endPoints = EndPoints.allMeals.url
        
        //responseType -> the main model
        taskForGETRequest(url:endPoints , responseType: MealsList.self) { (response, error) in
            if let response = response  {
                //result -> is the [meals]
                completion(response.meals,nil)
            } else {
                completion([],.UnAbleToComplete)
            }
        }
        
=======
        
//        refreshToken { success, error in
//            if error == nil {
                //responseType -> the main model
                taskForGETRequest(url:newUrl , responseType: MealsList.self) { (response, error) in
                    if let response = response  {
                        //result -> is the [meals]
                        completion(response.meals,nil)
                    } else {
                        completion([],error)
                        print(error)
                    }
                }
//            }else {
//                print(error?.localizedDescription)
//            }
//        }
    }
    
    
    class func getAllMealsList(completion: @escaping ([MealsResult], Error?) -> Void) {
        
        let endPoints = EndPoints.allMeals.url
        
//        refreshToken { success, error in
//            if error == nil {
                //responseType -> the main model
                taskForGETRequest(url:endPoints , responseType: MealsList.self) { (response, error) in
                    if let response = response  {
                        //result -> is the [meals]
                        completion(response.meals,nil)
                    } else {
                        completion([],error)
                        print(error)
                    }
                }
//            }else {
//                print(error?.localizedDescription)
//            }
//        }
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    }
 
    
    // API - Creating new order
    class func createOrder(completion:@escaping (NSError?) -> Void) {
        
<<<<<<< HEAD
        let simpleArray = Tray.currentTray.items
        let jsonArray = simpleArray.map { item in
            return [
                "meal_id": item.meal.id,
                "quantity": item.qty,
                "rest_id" : 0
            ]
        }
        
        if JSONSerialization.isValidJSONObject(jsonArray) {
            
            do {
                
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                
                let params: [String: Any] = [
                    "access_token": "\(Auth.accessToken)",
                    "restaurant_id": "\(Tray.currentTray.restaurant!.id)",
                    "order_details": dataString,
                    "address": Tray.currentTray.address!,
                    "phone_number"  : Tray.currentTray.Phone!
                ]
                
                
                
                Alamofire.request(EndPoints.makeAnOrder.url, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
                    switch response.result {
                    
                    case .success(let success):
                        completion( nil)
                        print(success)
                        break
                    case .failure(let error):
                        completion(error as NSError?)
                        print(error)
                        break
                    }
                }
                
            }
            catch {
                print("JSON serialization failed: \(error)")
            }
        }
=======
//        refreshToken { success, error in
//            if error == nil {
                
                let simpleArray = Tray.currentTray.items
                let jsonArray = simpleArray.map { item in
                    return [
                        "meal_id": item.meal.id,
                        "quantity": item.qty,
                        "rest_id" : item.delivery.delivery
                    ]
                }
                
                if JSONSerialization.isValidJSONObject(jsonArray) {
                    
                    do {
                        
                        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                        let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                        
                        let params: [String: Any] = [
                            "access_token": "\(Auth.accessToken)",
                            "restaurant_id": "\(Tray.currentTray.restaurant!.id)",
                            "order_details": dataString,
                            "address": Tray.currentTray.address!,
                            "phone_number"  : Tray.currentTray.Phone!
                        ]
                        
                        
                        
                        Alamofire.request(EndPoints.makeAnOrder.url, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
                            switch response.result {
                            
                            case .success(let success):
                                completion( nil)
                                print(success)
                                break
                            case .failure(let error):
                                completion(error as NSError?)
                                print(error)
                                break
                            }
                        }
                        
                    }
                    catch {
                        print("JSON serialization failed: \(error)")
                    }
                }
//            } else {
//                print(error?.localizedDescription)
//            }
//        }
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    }
    
    
    
    
    //use generic request to get AppLists from ArrayList Model (GET)
<<<<<<< HEAD
    class func getLatestOrders(completion: @escaping (Order?, GFError?) -> Void) {
=======
    class func getLatestOrders(completion: @escaping ([OrderDetails], Error?) -> Void) {
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        
        let endPoints = EndPoints.latestOrders.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
<<<<<<< HEAD
        //responseType -> the main model
        taskForGETRequest(url:newUrl , responseType: LatestOrders.self) { (response, error) in
            if let response = response  {
                //result -> is the [Order_details]
                completion(response.order,nil)
            } else {
                completion(nil,.UnAbleToComplete)
            }
        }
    }
    
    
    //use generic request to get AppLists from ArrayList Model (GET)
    class func getOrderDetails(completion: @escaping ([OrderDetails], GFError?) -> Void) {
        
        let endPoints = EndPoints.latestOrders.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        //responseType -> the main model
        taskForGETRequest(url:newUrl , responseType: LatestOrders.self) { (response, error) in
            if let response = response  {
                //result -> is the [Order_details]
                completion(response.order.order_details,nil)
            } else {
                completion([],.UnAbleToComplete)
            }
        }
=======
        
//        refreshToken { success, error in
//            if error == nil {
                //responseType -> the main model
                taskForGETRequest(url:newUrl , responseType: LatestOrders.self) { (response, error) in
                    if let response = response  {
                        //result -> is the [Order_details]
                        completion(response.order.order_details,nil)
                    } else {
                        completion([],error)
                        print(error)
                    }
                }
//            }else {
//                print(error?.localizedDescription)
//            }
//        }
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    }
    
    
    //use generic request to get AppLists from ArrayList Model (GET)
<<<<<<< HEAD
    class func getOrderStatus(completion: @escaping (Order?, GFError?) -> Void) {
        
        let endPoints = EndPoints.latestOrders.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        //responseType -> the main model
        taskForGETRequest(url:newUrl , responseType: LatestOrders.self) { (response, error) in
            if let response = response  {
                //result -> is the [Order_details]
                completion(response.order,nil)
            } else {
                completion(nil,.UnAbleToComplete)
            }
        }
    }
    
    //Getting Driver Location
    class func GetDriverLocation(completion: @escaping (ShowDriverLocation?, GFError?) -> Void) {
        
        let endPoints = EndPoints.getDriverLocation.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        
        taskForGETRequest(url:newUrl , responseType: ShowDriverLocation.self) { (response, error) in
            if let response = response  {
                //response -> is the {location}
                completion(response,nil)
            } else {
                completion(nil,error)
                print(error!.localizedDescription)
            }
        }
    }
    
    
                            /**************  Driver ***************/
    
    class func DriverGetReadyOrders(completion: @escaping ([TheDriverOrderDetails], GFError?) -> Void) {
        
        //responseType -> the main model
        taskForGETRequest(url:EndPoints.driverReadyOrders.url , responseType: DriverReadyOrders.self) { (response, error) in
            if let response = response  {
                //result -> is the [meals]
                completion(response.orders,nil)
            } else {
                completion([],.UnAbleToComplete)
            }
        }
=======
    class func getOrderStatus(completion: @escaping (Order, Error?) -> Void) {

        let endPoints = EndPoints.latestOrders.stringValue + "access_token=\(Auth.accessToken)"

        guard let newUrl = URL(string: endPoints) else {
            return
        }


            //responseType -> the main model
            taskForGETRequest(url:newUrl , responseType: LatestOrders.self) { (response, error) in
                if let response = response  {
                    //result -> is the [Order_details]
                    completion(response.order,nil)
                } else {
                    
                    print(error?.localizedDescription)
                }
            }
    }
    
    
    /**************  Driver ***************/
    
    class func DriverGetReadyOrders(completion: @escaping ([TheDriverOrderDetails], Error?) -> Void) {
        
            //responseType -> the main model
            taskForGETRequest(url:EndPoints.driverReadyOrders.url , responseType: DriverReadyOrders.self) { (response, error) in
                if let response = response  {
                    //result -> is the [meals]
                    completion(response.orders,nil)
                } else {
                    completion([],error)
                    print(error)
                }
            }
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
    }
    
    class func pickOrder(orderId: Int, completionHandler: @escaping ([String: Any]?) -> Void) {
        let path = "api/driver/order/pick/"
        let params: [String: Any] = [
            "order_id": "\(orderId)",
            "access_token": Auth.accessToken
        ]
        PostRequestManager.shared.requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
<<<<<<< HEAD
    class func DriverGetLatestOrders(completion: @escaping (TheDriverLatestOrderDetails?, GFError?) -> Void) {
=======
    class func DriverGetLatestOrders(completion: @escaping (TheDriverLatestOrderDetails?, Error?) -> Void) {
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
        
        let endPoints = EndPoints.driverLatestOrders.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        
        taskForGETRequest(url:newUrl , responseType: DriverLatestOrders.self) { (response, error) in
            if let response = response  {
                //result -> is the [meals]
                completion(response.order,nil)
            } else {
<<<<<<< HEAD
                completion(nil,.UnAbleToComplete)
                print(error!.localizedDescription)
            }
        }
    }
    
    
    class func DriverShowLatestOrders(completion: @escaping ([LatestDriverOrderDetails], GFError?) -> Void) {
        
        let endPoints = EndPoints.driverLatestOrders.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        
        taskForGETRequest(url:newUrl , responseType: DriverLatestOrders.self) { (response, error) in
            if let response = response  {
                //result -> is the [meals]
                completion(response.order.order_details,nil)
            } else {
                completion([],.UnAbleToComplete)
                print(error!.localizedDescription)
            }
        }
    }
    
    
    class func DriverShowDelivery(completion: @escaping (DriverLatestOrders?, GFError?) -> Void) {
        
        let endPoints = EndPoints.driverLatestOrders.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        
        taskForGETRequest(url:newUrl , responseType: DriverLatestOrders.self) { (response, error) in
            if let response = response  {
                //result -> is the [meals]
                completion(response,nil)
            } else {
                completion(nil,.UnAbleToComplete)
=======
                completion(nil,error)
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
                print(error!.localizedDescription)
            }
        }
    }
    
<<<<<<< HEAD
    
    
    //Update Driver Location
    class func updateLocation(location:CLLocationCoordinate2D,completion: @escaping (Bool, GFError?) -> Void ) {
        
        let body = UpdateDriverLocation(access_token: Auth.accessToken, location: "\(location.latitude),\(location.longitude)")
        taskForPOSTRequest(url: EndPoints.driverUpdateLocation.url, responseType: UpdateDriverLocationResponse.self, body: body) { (response, error) in
            if let response = response {
                completion(true, nil)
                print(response)
            } else {
                completion(false, error)
                print(error!)
            }
        }
        
    }
    
    
    //Update Driver Location
    class func updateDriverLocation(location: CLLocationCoordinate2D , completionHandler: @escaping ([String: Any]?) -> Void) {
        let path = "api/driver/location/update/"
        let params: [String: Any] = [
            "access_token": Auth.accessToken,
            "location": "\(location.latitude),\(location.longitude)"
        ]
        PostRequestManager.shared.requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    class func DriverCompleteOrder(orderId: Int, completion: @escaping (Bool, Error?)  -> Void) {
    
        let body = CompleteOrder(access_token: Auth.accessToken, order_id: orderId)
        secondTaskForPOSTRequest(url: EndPoints.driverCompleteOrder.url, responseType: CompleteOrderResponse.self, body: body) { (response, error) in
            if let response = response {
                print(response.status)
                completion(true, nil)
                print(response)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func DriverCancelOrder(orderId: Int, completion: @escaping ([String:Any]?)-> Void) {
        let path   = "api/driver/order/cancel/"
        let params : [String: Any] = [

            "order_id"    : orderId,
            "access_token": Auth.accessToken
            
        ]
        
        PostRequestManager.shared.requestServer(.post, path, params, URLEncoding(), completion)
    }
    
    class func DriverCompleteTheOrder(orderId: Int, completion: @escaping ([String:Any]?)-> Void) {
        let path   = "api/driver/order/complete/"
        let params : [String: Any] = [
        
            "order_id"    : orderId,
            "access_token": Auth.accessToken
        
        ]
        
        PostRequestManager.shared.requestServer(.post, path, params, URLEncoding(), completion)
    }
    
    class func DriverRevenue(completion: @escaping (RevenueData?, GFError?) -> Void) {
        
        let endPoints = EndPoints.driverRevenue.stringValue + "access_token=\(Auth.accessToken)"
        
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        
        taskForGETRequest(url:newUrl , responseType: Charts.self) { (response, error) in
            if let response = response  {
                //result -> is the [meals]
                completion(response.revenue,nil)
            } else {
                completion(nil,.UnAbleToComplete)
            }
        }
        
        
    }
    
=======
>>>>>>> 8c67f71eb814d2079ee60232badaef74c4c83c67
}
 
    



    


