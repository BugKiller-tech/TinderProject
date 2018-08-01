//
//  SignInWithViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import Toaster

class SignInWithViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backAction(_ sender: Any) {
        let transition = Transitions.getRightToLeftVCTransition()
        transition.type = kCATransitionReveal
//        view.layer.add(transition, forKey: kCATransition)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
   
    @IBAction func handleSigninWithFacebook(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil{
                print("custom login error")
                return
            }
            self.processFackbookSignup()
        }    }
    
    @IBAction func handleSigninWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    @IBAction func handleSigninWithEmail(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "signInWithEmailVC") as! SignInWithEmailViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    

    func processFackbookSignup(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }

        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)

        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                AppStatusNoty.showLoading(show: false);
                Toast(text: NSLocalizedString("Failed to sign with facebook account", comment: "")).show();
                print("faild to login ", err)
                return
            }
            guard let uid = user?.uid else { return }
            User.currentUser.id = uid
            User.currentUser.email = user?.email
          
            let ref = DBProvider.shared.userRef

            API.getCurrentUser(key: uid, completion: { (user) in
                AppStatusNoty.showLoading(show: false)
                if user == nil  {
                    Toast(text: "Please signup to use signin").show()
                    CommonAction.signout(isGotoFirstPage: false)
                    return;
                }
                User.currentUser = user!;
                CommonAction.gotoMainPage(currentVC: self)
            })

            print("succesufully logged into firebase using google account ", uid)
        })
    }
}
