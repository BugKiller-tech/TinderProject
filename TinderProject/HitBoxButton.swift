//
//  HitBoxButton.swift
//  TinderProject
//
//  Created by hkg328 on 7/14/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit

class HitBoxButton: UIButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let moreHitLen: CGFloat = -15
        let hitTestEdgeInsets = UIEdgeInsetsMake(moreHitLen, moreHitLen, moreHitLen, moreHitLen)
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
