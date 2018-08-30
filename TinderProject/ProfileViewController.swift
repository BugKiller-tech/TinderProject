//
//  ProfileViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import Toaster
import SDWebImage
import SwiftyJSON
import Alamofire

class ProfileViewController: UIViewController {
    
    var things: [Thing] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: SwiftyAvatar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initUIValues();
        
//        API.getMyNotSelledThings { (things) in
//            self.things = things
//        }
        
        getMyAvailableThigns()
    }
    
    
    func getMyAvailableThigns() {
        AppStatusNoty.showLoading(show: true)
        CUSTOM_API.getMyAvailableThings { (things) in
            AppStatusNoty.showLoading(show: false)
            self.things = things
        }
        
        
    }
    
    func initUIValues() {
        
        userNameLabel.text = User.currentUser.firstName! + " " + User.currentUser.lastName!
        if let url = User.currentUser.photoUri {
            if url != "" {
                self.profileImageView.sd_setImage(with: URL(string: url))
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBackAction(_ sender: Any) {
        let transition = Transitions.getRightToLeftVCTransition()
        view.layer.add(transition, forKey: kCATransition)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)

    }
    @IBAction func handleAddAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addThingVC") as! AddThingViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleGotoProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! MyThingCell
        let thing = self.things[indexPath.row]
        cell.titleLabel.text = thing.title!
        cell.imageView1.sd_setImage(with: URL(string: thing.images[0]))
        return cell
    }
}
