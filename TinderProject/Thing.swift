//
//  Thing.swift
//  TinderProject
//
//  Created by hkg328 on 8/1/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Thing {
    
    init() {

    }
    
//    init(data: [String: AnyObject]) {  // firebase
//        title = data["title"] as? String
//        category = data["category"] as? String
//        description = data["description"] as? String
//        price = data["price"] as? Double
//        ownerId = data["ownerId"] as? String
//        imageUrl1 = data["imageUrl1"] as? String
//        imageUrl2 = data["imageUrl1"] as? String
//        imageUrl3 = data["imageUrl1"] as? String
//        imageUrl4 = data["imageUrl1"] as? String
//        selled = data["selled"] as? Bool
//
//        if (imageUrl1 != "") { images.append(imageUrl1!) }
//        if (imageUrl2 != "") { images.append(imageUrl2!) }
//        if (imageUrl3 != "") { images.append(imageUrl3!) }
//        if (imageUrl4 != "") { images.append(imageUrl4!) }
//
//    }
    init(data: JSON) { // custom api
        title = data["title"].stringValue
        category = data["category"].stringValue
        description = data["description"].stringValue
        price = data["price"].doubleValue
        imageUrl1 = data["imageUrl1"].stringValue
        imageUrl2 = data["imageUrl2"].stringValue
        imageUrl3 = data["imageUrl3"].stringValue
        imageUrl4 = data["imageUrl4"].stringValue
        selled = data["selled"].boolValue
        
        if (imageUrl1 != "") { images.append(imageUrl1!) }
        if (imageUrl2 != "") { images.append(imageUrl2!) }
        if (imageUrl3 != "") { images.append(imageUrl3!) }
        if (imageUrl4 != "") { images.append(imageUrl4!) }
        
        owner = User()
        do {
            try owner?.name = data["user"]["name"].stringValue
            try owner?._id = data["user"]["_id"].stringValue
        } catch (_) {
            
        }
        
    }
    
    
    var title: String?
    var category: String?
    var description: String?
    var price: Double?
    var ownerId: String?
    var owner: User?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var imageUrl4: String?
    
    var images: [String] = []
    
    var selled: Bool? = false
}
