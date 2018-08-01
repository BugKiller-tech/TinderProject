//
//  DealViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/19/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit

class DealViewController: UIViewController {
    
    @IBOutlet weak var thingImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        thingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoDetailPage)))
    }
    
    @objc func gotoDetailPage() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleDeal(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "dealedVC") as! DealedViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleNoDeal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
