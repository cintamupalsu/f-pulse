//
//  Setting.swift
//  Mujin
//
//  Created by アリフ on 2021/06/03.
//

import UIKit

class Setting: NSObject, NSCoding {
    //var user: User
    var email: String
    var token: String
    var name: String
    var admin: String
    
    //init(user: User){
    init(email: String, token: String, name: String, admin: String){
        //self.user = user
        self.email = email
        self.token = token
        self.name = name
        self.admin = admin
    }
    
    required init?(coder aDecoder: NSCoder) {
        //self.user = aDecoder.decodeObject(forKey: "user") as! User
        self.email = aDecoder.decodeObject(forKey: "email" ) as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.admin = aDecoder.decodeObject(forKey: "admin") as! String
    }
    
    func encode(with aCoder: NSCoder){
        //aCoder.encode(user, forKey: "user")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(admin, forKey: "admin")
    }
    
}
