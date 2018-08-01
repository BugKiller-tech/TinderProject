//
//  Transition.swift
//  TinderProject
//
//  Created by hkg328 on 7/14/18.
//  Copyright © 2018 HC. All rights reserved.
//

import Foundation
import UIKit

class Transitions {
    static func getRightToLeftVCTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return transition
    }
    static func getLeftToRightVCTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return transition
    }
}
