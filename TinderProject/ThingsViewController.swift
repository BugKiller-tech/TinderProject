//
//  ThingsViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/9/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import Toaster
import Toast_Swift

class ThingsViewController: UIViewController {
    
    var things: [Thing] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true;

        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        API.getMatchedThingsToMeAvailable { (things) in
            self.things = things
        }
//        getMatchedThingsToMeAvailable
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func handleBackAction(_ sender: Any) {
        let transition = Transitions.getLeftToRightVCTransition()
        view.layer.add(transition, forKey: kCATransition)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func handleGotoInbox(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "superLikesVC") as! SuperLikesViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func displaySearchBar(_ sender: Any) {
        searchBar.isHidden = false;
    }
}


extension ThingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.things.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MatchedThingCell
        let thing = self.things[indexPath.row]
        cell.imageView1.sd_setImage(with: URL(string: thing.images[0]))
        cell.titleLabel.text = thing.title
        cell.descriptionLabel.text = thing.description
        return cell
    }
}
