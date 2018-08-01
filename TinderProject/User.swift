//
//  User.swift
//  TinderProject
//
//  Created by hkg328 on 7/19/18.
//  Copyright © 2018 HC. All rights reserved.
//

import Foundation


struct AppUser {
    
    static var currentUser = AppUser()
    
    var id: String?
    var firstName: String? = ""
    var lastName: String? = ""
    var email: String? = ""

    var notification: String? = ""
    var photoUri: String? = ""
}
