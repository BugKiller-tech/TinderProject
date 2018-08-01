//
//  ViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/7/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import Toaster

class SignInRegisterController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus();
    }
    func checkAuthStatus() {
        if Auth.auth().currentUser != nil {
            CommonAction.gotoMainPage()
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gotoSignInPage(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "signInWithVC") as! SignInWithViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func gotoRegisterPage(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "registerWithVC") as! RegisterWithViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}

