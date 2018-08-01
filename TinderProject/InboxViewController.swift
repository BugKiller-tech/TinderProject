//
//  InboxViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/13/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBackAction(_ sender: Any) {
//        let transition = Transitions.getRightToLeftVCTransition()
//        transition.type = kCATransitionReveal
//        //        view.layer.add(transition, forKey: kCATransition)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func handleShowDealedVC(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "dealedVC") as! DealedViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
}
