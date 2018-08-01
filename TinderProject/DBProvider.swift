//
//  DBProvider.swift
//  TinderProject
//
//  Created by hkg328 on 7/19/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase


class DBProvider{
    
    private static let _instance = DBProvider()
    private init() {
        
    }
    
    static var shared: DBProvider {
        return _instance
    }
    
    var dbRef: DatabaseReference{
        return Database.database().reference();
    }
    var userRef: DatabaseReference{
        return dbRef.child("users")
    }
    
    var categoryRef: DatabaseReference {
        return dbRef.child("categories")
    }
    
    var thingsRef: DatabaseReference {
        return dbRef.child("things")
    }
    
    var messageRef: DatabaseReference {
        return dbRef.child("messages")
    }
    
    
    //storage ref..
    
    var storageRef: StorageReference{
        return Storage.storage().reference()
    }
    
    var userProfileImageStorage: StorageReference {
        return storageRef.child("avatars")
    }
    
    var thingsImageStorage: StorageReference {
        return storageRef.child("things")
    }
    
}


































