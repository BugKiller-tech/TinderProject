//
//  API.swift
//  TinderProject
//
//  Created by hkg328 on 7/19/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase


class API {
    
    public static func makeUser(item: DataSnapshot) -> User {
        var user = User()
        user.id = item.key
        var dict = item.value as! [String: AnyObject]
        user.firstName = dict["firstName"] as? String
        user.lastName = dict["lastName"] as? String
        user.email = dict["email"] as? String
        user.notification = dict["notification"] as? String

        if let uri = dict["photoUri"] as? String {
            user.photoUri = uri
        }
        
        if let minPrice = dict["minPrice"] as? Float {  user.minPrice = minPrice  }
        if let maxPrice = dict["maxPrice"] as? Float {  user.maxPrice = maxPrice  }
        if let radius = dict["radius"] as? Float {  user.radius = radius  }
        if let category = dict["category"] as? String {
            if category != "" { user.category = category }
        }
        if let currentThing = dict["currentThing"] as? String {
            user.currentThing = currentThing
        }
        
        
        return user
    }
    
    public static func getCurrentUser (key: String, completion: @escaping (_ user: User?) -> Void) {
        DBProvider.shared.userRef.child(key).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                var user = API.makeUser(item: snapshot)
                completion(user)
            } else {
                completion(nil)
            }
        }, withCancel: {(error) in
            
            print("asdf")
        })
    }
    
    
    public static func getCategories(completion: @escaping (_ categoires: [String]) -> Void) {
        var categories: [String] = [];
        DBProvider.shared.categoryRef
            .queryOrdered(byChild: "rank")
            .observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists() {
                
                for child in snapshot.children {
                    var item = child as! DataSnapshot
                    var data = item.value as! [String: AnyObject]
                    categories.append(data["name"] as! String)
                }
                
                
                print("fetched all the categories")
                completion(categories)
                
            }
            
        }
    }
    
    public static func makeThingsArray(snapshot: DataSnapshot) -> [Thing] {
        var things: [Thing] = []
        
        for child in snapshot.children  {
            var item = child as! DataSnapshot
            var data = item.value as! [String: AnyObject]
            var thing = Thing(data: data)
            things.append(thing)
        }
        return things
    }
    
    public static func getMyNotSelledThings(completion: @escaping(_ things: [Thing]) -> Void) {
        if let id = User.currentUser.id {
            
            DBProvider.shared.thingsRef.queryOrdered(byChild: "ownerId").queryEqual(toValue: id).observeSingleEvent(of: .value) { (snapshot) in
                var things = makeThingsArray(snapshot: snapshot)
                var rltThings: [Thing] = []
                for thing in things {
                    if thing.selled == false {
                        rltThings.append(thing)
                    }
                }
                completion(rltThings)
            }
        } else {
            completion([])
        }
    }
    public static func getMatchedThingsToMeAvailable(completion: @escaping(_ things: [Thing]) -> Void) {
        if let id = User.currentUser.id {
            
            DBProvider.shared.thingsRef.queryOrdered(byChild: "category").queryEqual(toValue: User.currentUser.category).observeSingleEvent(of: .value) { (snapshot) in
                var things = makeThingsArray(snapshot: snapshot)
                var rltThings: [Thing] = []
                for thing in things {
                    if thing.selled == false && thing.ownerId != User.currentUser.id {
                        rltThings.append(thing)
                    }
                }
                completion(rltThings)
            }
        } else {
            completion([])
        }
    }
    
}










































































