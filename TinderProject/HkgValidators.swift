//
//  HkgValidators.swift
//  TinderProject
//
//  Created by hkg328 on 7/19/18.
//  Copyright © 2018 HC. All rights reserved.
//

import Foundation


class HkgValidators {
    public static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}




























