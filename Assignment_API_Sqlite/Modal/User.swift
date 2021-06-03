//
//  User.swift
//  Assignment_API_Sqlite
//
//  Created by Mirajkar on 01/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import Foundation


struct User {
    var id : Int?
    var name : String?
    var email : String?
    var zipcode : String?
    var companyName : String?
    
    
    init(id: Int?, name: String?, email: String?, zipcode: String?, companyName: String? ) {
        self.id = id
        self.name = name
        self.email = email
        self.zipcode = zipcode
        self.companyName = companyName
    }
}
