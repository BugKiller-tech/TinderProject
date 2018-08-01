//
//  CommonAction.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit


class CommonAction {
    static func gotoMainPage(currentVC: UIViewController? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        DispatchQueue.main.async {
            if currentVC == nil {
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    delegate.window?.rootViewController = vc
                }
            } else {
                currentVC?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    static func signout(isGotoFirstPage: Bool = true) {
        do { GIDSignIn.sharedInstance().signOut() } catch let err {  }
        do {
            try Auth.auth().signOut()
            FBSDKAccessToken.setCurrent(nil)
            
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                if isGotoFirstPage {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "signInRegisterVC") as! SignInRegisterController
                    delegate.window?.rootViewController = vc
                }
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
