//
//  Validate.swift
//  Live
//
//  Created by hkg328 on 6/30/18.
//  Copyright © 2018 io.ltebean. All rights reserved.
//

import Foundation


extension String {
    var isAlpha: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}
