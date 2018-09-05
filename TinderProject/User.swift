//
//  User.swift
//  TinderProject
//
//  Created by hkg328 on 7/19/18.
//  Copyright © 2018 HC. All rights reserved.
//

import Foundation


struct User {
    
    static var currentUser = User()
    
    var id: String?
    var firstName: String? = ""
    var lastName: String? = ""
    var email: String? = ""

    var notification: String? = ""
    var photoUri: String? = ""
    
    var minPrice: Float = 0
    var maxPrice: Float = 100
    var radius: Float = 30
    var category: String = "Other"
    
    var currentThing: String = "";
    
    var _id: String? = "" // mongo id
    var name: String? = "" // this is saved on mongo
}
