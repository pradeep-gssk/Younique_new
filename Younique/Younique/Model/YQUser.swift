//
//  YQUser.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/27/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQUser: NSObject, NSCoding {
    
    var userName: String?
    var accessToken: String = ""
    var bag : [String : YQItem] = [:]
    
    static let shared = YQUser.loadLoggedInUser()

    class func loadLoggedInUser() -> YQUser {
        if let  archivedObject = UserDefaults.standard.object(forKey:USER_PROFILE_DATA){
            if let user  = NSKeyedUnarchiver.unarchiveObject(with: (archivedObject as! NSData) as Data) as? YQUser {
                return user;
            }
        }
        
        return YQUser()
    }
    
    override init() {
        
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: USER_PROFILE_DATA)
        UserDefaults.standard.synchronize()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.accessToken, forKey: "accessToken")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String
    }
}
