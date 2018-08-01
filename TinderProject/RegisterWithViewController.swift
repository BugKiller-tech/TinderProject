//
//  RegisterWithViewController.swift
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


import SCLAlertView


class RegisterWithViewController: UIViewController, GIDSignInUIDelegate {

//    let fbSignButton = {
//
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self;
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
    
    @IBAction func handleSignupwithFacebook(_ sender: Any) {
//        SignupData.initSignupData()
//        displayInputAlert(isGoogoeSignIn: false)
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil{
                print("custom login error")
                return
            }
            // print(result?.token.tokenString)
            self.processFackbookSignup()
        }
    }
    
    @IBAction func handleSignupwithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
//        SignupData.initSignupData()
//        displayInputAlert(isGoogoeSignIn: true)
        
    }
//    func displayInputAlert(isGoogoeSignIn: Bool = true) {
//        let appearance = SCLAlertView.SCLAppearance(
//            showCloseButton: false,
//            shouldAutoDismiss: false
//        )
//        let alertView = SCLAlertView(appearance: appearance)
//        let firstNameTF = alertView.addTextField(NSLocalizedString("Enter first name", comment: ""))
//        let lastNameTf = alertView.addTextField(NSLocalizedString("Enter last name", comment: ""))
//
//        alertView.addButton(NSLocalizedString("Sign up", comment: "")) {
//            if firstNameTF.text == "" {
//                self.view.makeToast(NSLocalizedString("Please input the first name", comment: ""))
//                return;
//            }
//            if lastNameTf.text == "" {
//                self.view.makeToast(NSLocalizedString("Please input the last name", comment: ""))
//                return;
//            }
//
//            SignupData.firstName = firstNameTF.text
//            SignupData.lastName = lastNameTf.text
//
//            if isGoogoeSignIn {
//                GIDSignIn.sharedInstance().signIn()
//            } else { // facebook
//                FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
//                    if err != nil{
//                        print("custom login error")
//                        return
//                    }
//                    // print(result?.token.tokenString)
//                    self.processFackbookSignup()
//                }
//            }
//            alertView.hideView()
//        }
//        alertView.addButton(NSLocalizedString("Cancel", comment: "")) {
//            alertView.hideView()
//        }
//        alertView.showInfo(NSLocalizedString("Signup", comment: ""), subTitle: "Please write the proper info")
//    }
    
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
            User.currentUser.firstName = SignupData.firstName
            User.currentUser.lastName = SignupData.lastName
            
            let ref = DBProvider.shared.userRef
            let values = [
                "id": uid,
                "email": User.currentUser.email,
                "firstName": user?.displayName,
                "lastName": "",
                "photoUri": user?.photoURL
                ] as [String : Any]
            
            DBProvider.shared.userRef.child(uid).setValue(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    Toast(text: "Can not sign up with facebook").show()
                    CommonAction.gotoMainPage(currentVC: self)
                    return;
                }
                Toast(text: "Successfully signed up with facebook").show()
                CommonAction.gotoMainPage(currentVC: self)
                
            })
            print("succesufully logged into firebase using google account ", uid)
        })
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
//            if err != nil { return }
//            print (result)
//        }
    }
    
    
    @IBAction func handleSignupwithEmail(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "registerWithEmailVC") as! RegisterWithEmailViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    

}
