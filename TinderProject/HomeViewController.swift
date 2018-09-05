//
//  HomeViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import CoreLocation
import APScheduledLocationManager


class HomeViewController: UIViewController {

    var isHowToDisplayed = false;
    var locManager: APScheduledLocationManager!
    
    var things: [Thing] = []
    var currentThingIndex: Int = 0 {
        didSet {
            if currentThingIndex >= things.count {
                self.currentThingIndex = 0;
                self.fetchCandidateItems();
            }
            
            if currentThingIndex < 0 {
                currentThingIndex = things.count - 1
            }
            if things.count > 0 && currentThingIndex >= 0 && currentThingIndex < things.count {
                self.thingImageView.sd_setImage(with: URL(string: things[currentThingIndex].images[0]))
                self.thingUserNameLabel.text = things[currentThingIndex].owner?.name
                self.thingNameLabel.text = things[currentThingIndex].title
            }
        }
    }
    
    
    @IBOutlet weak var thingImageView: UIImageView!
    @IBOutlet var thingUserNameLabel: UILabel!
    @IBOutlet var thingNameLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUploadDriverLocationToServer()
        // Do any additional setup after loading the view.
        fetchCurrentUser();
        thingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoDetailPage)))
        
        self.appendSwipeGestureForNextThing()
    }
    
    func appendSwipeGestureForNextThing() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.responseToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.responseToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    @objc func responseToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.currentThingIndex = self.currentThingIndex + 1;
                break;
            case UISwipeGestureRecognizerDirection.left:
                self.currentThingIndex = self.currentThingIndex - 1;
                break;
            default:
                break;
            }
        }
        
    }
    
    func fetchCandidateItems() {
        AppStatusNoty.showLoading(show: true)
        CUSTOM_API.getCandidateItems { (things) in
            AppStatusNoty.showLoading(show: false)
            debugPrint(things)
            self.things = things
            self.currentThingIndex = 0;
        }
        
    }
    @objc func gotoDetailPage() {
        if self.things.count == 0 { return }
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        vc.thing = self.things[self.currentThingIndex]
        present(vc, animated: true, completion: nil)
    }
    func setupUploadDriverLocationToServer(){
        self.locManager = APScheduledLocationManager(delegate: self)
        self.locManager.requestAlwaysAuthorization()
        self.locManager.startUpdatingLocation(interval: 30)
    }
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        User.currentUser.id = uid
        
        
        AppStatusNoty.showLoading(show: true)
        API.getCurrentUser(key: uid) { (user) in
            AppStatusNoty.showLoading(show: false)
            if let user1 = user {
                User.currentUser = user1;
                
                let params = [
                    "firebaseId": uid,
                    "name": User.currentUser.firstName! + " " + User.currentUser.lastName!
                ]
                Alamofire.request(CUSTOM_API.REGISTER_USER, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                    .responseJSON { (response) in
                        switch response.result {
                        case .success:
                            print(response)
                        case .failure(let error):
                            print(error)
                        }
                }
            }
        }
        
        
        API.getCategories { (categories) in
            AppCommon.categories = categories
            print(categories)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        isHowToDisplayed = defaults.bool(forKey: "isHowToDisplayed")
        if !isHowToDisplayed {
            self.displayHowToPlayController()
            self.isHowToDisplayed = true
            defaults.setValue(true, forKey: "isHowToDisplayed")
        }
        if self.things.count == 0 {
            fetchCandidateItems();
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


extension HomeViewController: APScheduledLocationManagerDelegate {
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didFailWithError error: Error) {
        
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = locations.last?.coordinate
        print("locations = \(locValue?.latitude) \(locValue?.longitude)")
        guard let lat = locValue?.latitude else { return }
        guard let lng = locValue?.longitude else { return }
        debugPrint(lat, lng)
        CUSTOM_API.updateUserLocation(params: [
            "lat": lat,
            "lng": lng
        ]) {
            
        }
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    
}



