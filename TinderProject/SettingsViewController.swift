//
//  SettingsViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
import DropDown
import ALCameraViewController
import ImagePicker
import Toaster
import SDWebImage

class SettingsViewController: UIViewController {
    
    let dropDown = DropDown()
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var pickCategoryView: EffectView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var pickedRadiusLabel: UILabel!
    
    
    @IBOutlet weak var minPriceTF: UITextField!
    @IBOutlet weak var maxPriceTF: UITextField!
    
    
    
    
    
    
    
    var categories: [String] = [] {
        didSet {
            self.dropDown.dataSource = categories
            self.dropDown.reloadAllComponents()
        }
    }
    
    
    func initUIValues() {
        self.userNameLabel.text = User.currentUser.firstName! + " " + User.currentUser.lastName!
        if let url = User.currentUser.photoUri {
            if url != "" {
                self.profileImageView.sd_setImage(with: URL(string: url))
            }
        }
        
        self.radiusSlider.setValue(User.currentUser.radius, animated: true)
        self.pickedRadiusLabel.text = "\(Int(self.radiusSlider.value)) km"
        
        self.minPriceTF.text = "\(User.currentUser.minPrice)"
        self.maxPriceTF.text = "\(User.currentUser.maxPrice)"
        self.categoryLabel.text = "\(User.currentUser.category)"
        
        self.categories = AppCommon.categories
        configureCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIValues();
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func configureCategory() {
        dropDown.anchorView = self.pickCategoryView
        dropDown.selectionAction = { [](index: Int, item: String) in
            self.categoryLabel.text = item;

        }
        
        pickCategoryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDropDown)));
    }
    
    @objc func showDropDown() {
        self.dropDown.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func radiusSliderChanged(_ sender: Any) {
        self.pickedRadiusLabel.text = "\(Int(self.radiusSlider.value)) km"
    }
    

    @IBAction func handleBackAction(_ sender: Any) {
//        let transition = Transitions.getRightToLeftVCTransition()
//        transition.type = kCATransitionReveal
//        //        view.layer.add(transition, forKey: kCATransition)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.dismiss(animated: false, completion: nil)
        
        if minPriceTF.text == "" {
            self.view.makeToast(NSLocalizedString("Can't be blank min price", comment: ""))
            return;
        }
        if maxPriceTF.text == "" {
            self.view.makeToast(NSLocalizedString("Can't be blank max price", comment: ""))
            return;
        }
        
        var minPrice = (self.minPriceTF.text! as NSString).floatValue
        var maxPrice = (self.maxPriceTF.text! as NSString).floatValue
        
        if minPrice > maxPrice {
            self.view.makeToast(NSLocalizedString("Max price mast be greater than min price", comment: ""))
            return;
        }
        
        
        AppStatusNoty.showLoading(show: true)
        DBProvider.shared.userRef.child(User.currentUser.id!).updateChildValues([
            "category": self.categoryLabel.text!,
            "radius": self.radiusSlider.value,
            "minPrice": self.minPriceTF.text!,
            "maxPrice": self.maxPriceTF.text!
        ]) { (error, ref) in
            
            User.currentUser.category = self.categoryLabel.text!
            User.currentUser.radius = self.radiusSlider.value
            User.currentUser.minPrice = (self.minPriceTF.text! as NSString).floatValue
            User.currentUser.maxPrice = (self.maxPriceTF.text! as NSString).floatValue
            
            
            DispatchQueue.main.async {
                AppStatusNoty.showLoading(show: false)
                self.dismiss(animated: true, completion: nil)
            }
        }
   }
    
    @IBAction func hanldeLogout(_ sender: Any) {
        CommonAction.signout()
    }
    @IBAction func handleEditProfilePicture(_ sender: Any) {
        self.handleImageSelect()
    }
    
    
    func handleImageSelect() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        let actionController = UIAlertController(title: NSLocalizedString("PhotoSource", comment: ""), message: NSLocalizedString("Please select the image source", comment: ""), preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Take Picture", comment: ""), style: .default) { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            picker.delegate = self
        }
        
        let libraryAction = UIAlertAction(title: NSLocalizedString("From Photo Library", comment: ""), style: .default) { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            picker.delegate = self
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
            
        }
        
        actionController.addAction(cameraAction)
        actionController.addAction(libraryAction)
        actionController.addAction(cancelAction)
        
        actionController.popoverPresentationController?.sourceView = self.profileImageView
        actionController.popoverPresentationController?.sourceRect = self.profileImageView.bounds
        
        present(actionController, animated: true, completion: nil)
        
//        let camViewController = CameraViewController(croppingParameters: CroppingParameters.init(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 100, height: 100)), allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true){[weak self] image, asset in
//            if image != nil {
//                self?.profileImageView.image = image
//
//                let imageName = NSUUID().uuidString + ".jpg"
//                var ref = DBProvider.shared.userProfileImageStorage.child(imageName)
//                if let uploadData = UIImageJPEGRepresentation((self?.profileImageView.image!)!, 0.2){
//                    let metadata = StorageMetadata()
//                    metadata.contentType = "image/jpeg"
//
//                    AppStatusNoty.showLoading(show: true)
//                    ref.putData(uploadData, metadata: metadata, completion: { (metadata, error) in
//                        DispatchQueue.main.async { AppStatusNoty.showLoading(show: false) }
//                        if error != nil {
//                            print(error)
//                            Toast(text: NSLocalizedString("something went wrong", comment: "")).show()
//                            return
//                        }
//                        let imageUrl = metadata?.downloadURL()?.absoluteString
//                        User.currentUser.photoUri = imageUrl
////                        if let url = User.currentUser.photoUri {
////                            DispatchQueue.main.async {
////                                self?.profileImageView.sd_setImage(with: URL(string: url))
////                            }
////                        }
//                        DBProvider.shared.userRef.child(User.currentUser.id!).updateChildValues([
//                            "photoUri": imageUrl
//                            ])
//                    })
//                }
//            }
//            self?.dismiss(animated: true, completion: nil)
//        }
//        present(camViewController, animated: true, completion: nil)
    }
}





extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image pick canceled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            if selectedImage != nil {
                self.profileImageView.image = selectedImage
                
                let imageName = NSUUID().uuidString + ".jpg"
                var ref = DBProvider.shared.userProfileImageStorage.child(imageName)
                if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.2){
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    AppStatusNoty.showLoading(show: true)
                    ref.putData(uploadData, metadata: metadata, completion: { (metadata, error) in
                        DispatchQueue.main.async { AppStatusNoty.showLoading(show: false) }
                        if error != nil {
                            print(error)
                            Toast(text: NSLocalizedString("something went wrong", comment: "")).show()
                            return
                        }
                        let imageUrl = metadata?.downloadURL()?.absoluteString
                        User.currentUser.photoUri = imageUrl
                        DBProvider.shared.userRef.child(User.currentUser.id!).updateChildValues([
                            "photoUri": imageUrl
                            ])
                    })
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}







































