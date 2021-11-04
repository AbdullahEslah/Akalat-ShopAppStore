//
//  PostRequestManager.swift
//  Akalat Shop
//
//  Created by Macbook on 04/09/2021.
//

import Foundation
import Alamofire

class PostRequestManager {
    
    
    static let shared = PostRequestManager() // Singltone
    
    let baseURL = NSURL(string: "http://www.akalatshop.com")
    
    // Request Server function  or user instead of JSON? -> [String: Any]
    func requestServer(_ method: HTTPMethod,_ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding,_ completionHandler: @escaping ([String:Any]?) -> Void ) {
        
        let url = baseURL!.appendingPathComponent(path)
        
        Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: nil).responseJSON{ response in
            
            switch response.result {
            case .success(let value):
                let jsonData = (value) as? [String:Any]
                completionHandler(jsonData)
                break
                
            case .failure:
                completionHandler(nil)
                break
            }
        }
    }
}
