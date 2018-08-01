//
//  HomeViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    var isHowToDisplayed = false;
    @IBOutlet weak var thingImageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCurrentUser();
        
        
        thingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoDetailPage)))
    }
    @objc func gotoDetailPage() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        present(vc, animated: true, completion: nil)
    }
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        API.getCurrentUser(key: uid) { (user) in
            if let user1 = user {
                User.currentUser = user1;
            }
        }
        
        
        API.getCategories { (categories) in
            AppCommon.categories = categories
            print(categories)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let defaults = UserDefaults.standard
        isHowToDisplayed = defaults.bool(forKey: "isHowToDisplayed")
        if !isHowToDisplayed {
            self.displayHowToPlayController()
            self.isHowToDisplayed = true
            defaults.setValue(true, forKey: "isHowToDisplayed")
        }
    }
    
    func displayHowToPlayController() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "howToVC") as! HowToPlayController
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoProfilePage(_ sender: Any) {
        let transition = Transitions.getLeftToRightVCTransition()
        //        self.view.layer.add(transition, forKey: "leftToRight")
        let vc = storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func gotoChatPage(_ sender: Any) {
        let transition = Transitions.getRightToLeftVCTransition()
        let vc = storyboard?.instantiateViewController(withIdentifier: "thingsVC") as! ThingsViewController
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    

}
