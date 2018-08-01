//
//  ButtonWithImage.swift
//  Live
//
//  Created by hkg328 on 3/11/18.
//  Copyright © 2018 io.ltebean. All rights reserved.
//

import UIKit


class ButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {

            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: (bounds.width - (imageView?.frame.height)!))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageView?.frame.width)!, bottom: 0, right: 0)
//            imageView?.backgroundColor = .blue
//            titleLabel?.backgroundColor = .red
        }
    }
}
