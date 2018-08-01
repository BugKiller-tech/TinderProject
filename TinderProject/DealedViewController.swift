//
//  DealedViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/13/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit

class DealedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))

        // Do any additional setup after loading the view.
    }
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
