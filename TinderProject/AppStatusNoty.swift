//
//  AppStatusNoty.swift
//  DeliveryCustomerApp
//
//  Created by Admin on 7/24/17.
//  Copyright © 2017 HC. All rights reserved.
//
//
//  LoadingStatus.swift
//  hkg328
//
//  Created by Admin on 7/5/17.
//  Copyright © 2017 HC. All rights reserved.
//

import UIKit


class AppStatusNoty {
    static let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    static let loadingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    static func showLoading(show: Bool){
        if let window = UIApplication.shared.keyWindow{
            if show == true {
                blackView.frame = window.frame
                blackView.alpha = 0
                //                blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                window.addSubview(blackView)
                loadingView.frame = CGRect(x: window.frame.width/2 - 25, y: window.frame.height/2 - 25, width: 50, height: 50)
                window.addSubview(loadingView)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    AppStatusNoty.blackView.alpha = 1 //even if this is 1, blackview's background color alpha is .5, so That is some opacity hkg.
                    AppStatusNoty.loadingView.startAnimating()
                }, completion: nil
                )
            }else{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    AppStatusNoty.blackView.alpha = 0
                    AppStatusNoty.loadingView.stopAnimating()
                })
            }
        }
        
    }
    
    static func alertToUser(title: String, message: String, viewController: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    static func sendNotification(_ msg: String){
        let notification = UILocalNotification()
        notification.alertTitle = "Cycliry App"
        notification.alertBody = msg
        notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
        UIApplication.shared.scheduledLocalNotifications = [notification]
    }
}

