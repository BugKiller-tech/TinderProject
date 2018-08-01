//
//  RegisterWithEmailViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
import Toaster

class RegisterWithEmailViewController: UIViewController {
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        // Do any additional setup after loading the view.
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
    
    @IBAction func handleRegister(_ sender: Any) {
        if !isValidInput() { return;  }
        
        guard let firstName = firstNameTF.text else { return; }
        guard let lastName = lastNameTF.text else { return; }
        guard let email = emailTF.text else { return; }
        guard let password = passwordTF.text else { return; }
        
        AppStatusNoty.showLoading(show: true)
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                AppStatusNoty.showLoading(show: false)
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                        case .invalidEmail:
                            self.view.makeToast(NSLocalizedString("You entered invalid email", comment: ""))
                        case .emailAlreadyInUse:
                            self.view.makeToast(NSLocalizedString("The email is already in use", comment: ""))
                        default:
                            self.view.makeToast(NSLocalizedString("Something went wrong", comment: ""))
                    }
                }
                return;
            }
            if let uid = user?.uid {
                let values = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                ]
                DBProvider.shared.userRef.child(uid).setValue(values, withCompletionBlock: { (error, dbRef) in
                    AppStatusNoty.showLoading(show: false)
                    if error != nil {
                        self.view.makeToast(NSLocalizedString("Can not register user with email", comment: ""))
                        return;
                    }
                    self.view.makeToast(NSLocalizedString("Successfully registered with email", comment: ""));
                    
                    CommonAction.gotoMainPage(currentVC: self)
                    
                })
            }
        }
    }
    
    func isValidInput() -> Bool {
        if firstNameTF.text == "" { self.view.makeToast(NSLocalizedString("Please input the first name", comment: "")); return false;  }
        if lastNameTF.text == "" { self.view.makeToast( NSLocalizedString("Please input the last name", comment: "")); return false;  }
        if emailTF.text == "" { self.view.makeToast(NSLocalizedString("Please input the email", comment: "")); return false;  }
        if !HkgValidators.isValidEmail(testStr: emailTF.text!) {
            self.view.makeToast(NSLocalizedString("Please input the valid email", comment: ""))
            return false;
        }
     
        if passwordTF.text == "" { self.view.makeToast(NSLocalizedString("Please input the password", comment: "")); return false;  }
        guard let pwdLength = passwordTF.text?.length else { return false; }
        if pwdLength < 6 { self.view.makeToast(NSLocalizedString("Your password must contain 6 or more digits", comment: "")); return false; }
        
        return true;
    }
    
}



































