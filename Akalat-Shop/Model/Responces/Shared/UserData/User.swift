//
//  User.swift
//  Akalat Shop
//
//  Created by Macbook on 6/17/21.
//

import Foundation

class User {
    
    var name: String?
    var email: String?
    var pictureURL: String?
    var imageURL: URL?
    
    //we use this to get an instance of user data
    static let currentUser = User()
    
    func setInfo(json: [String: Any]) {
        self.name = json["name"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.imageURL = json["imageURL"] as? URL 
        
        let image = json["picture"] as? [String:Any]
        let data = image?["data"] as? [String:Any]
        
        self.pictureURL = data?["url"] as? String ?? ""
    }
    
    func resetInfo() {
        self.name = nil
        self.email = nil
        self.pictureURL = nil
        self.imageURL = nil
        
    }
    
}
