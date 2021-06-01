//
//  User.swift
//  Assignment_API_Sqlite
//
//  Created by Mirajkar on 01/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import Foundation


struct User {
    var name : String?
    var email : String?
    var zipcode : String?
    var companyName : String?
    
    
    init(name: String?, email: String?, zipcode: String?, companyName: String? ) {
        self.name = name
        self.email = email
        self.zipcode = zipcode
        self.companyName = companyName
    }
}
