//
//  User 2.swift
//  iosdemo
//
//  Created by Mihika Sharma on 29/03/25.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    var email: String?
    
    var emailVerified: Bool?
    
    var authData: [String : [String : String]?]?
    
    var originalData: Data?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var ACL: ParseSwift.ParseACL?
    
    var objectId: String?
    var username: String?
    var password: String?
}
