//
//  SignInWithEmailViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift


class SignInWithEmailViewController: UIViewController {
    
    
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
    
    @IBAction func handleSignIn(_ sender: Any) {
        if !isValidInput() { return;  }
        
        guard let email = emailTF.text else { return; }
        guard let password = passwordTF.text else { return; }
        
        AppStatusNoty.showLoading(show: true)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            AppStatusNoty.showLoading(show: false)
            if error != nil {
                self.view.makeToast(NSLocalizedString("Please input the valid credential", comment: ""))
                return;
            }
            
            self.view.makeToast(NSLocalizedString("Successfully signed in", comment: ""))
            CommonAction.gotoMainPage(currentVC: self)
        }
    }
    
    
    func isValidInput() -> Bool {
        if emailTF.text == "" { self.view.makeToast(NSLocalizedString("Please input the email", comment: "")); return false;  }
        if !HkgValidators.isValidEmail(testStr: emailTF.text!) {
            self.view.makeToast(NSLocalizedString("Please input the valid email", comment: ""))
            return false;
        }
        if passwordTF.text == "" { self.view.makeToast(NSLocalizedString("Please input the password", comment: "")); return false;  }
        return true;
    }
    
}
