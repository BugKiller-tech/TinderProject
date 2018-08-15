//
//  AddThingViewController.swift
//  TinderProject
//
//  Created by hkg328 on 7/11/18.
//  Copyright © 2018 HC. All rights reserved.
//

import UIKit
import DropDown
import Firebase
import Toaster
import Toast_Swift

class AddThingViewController: UIViewController {
    
    
    @IBOutlet weak var titleTF: UITextField!
    
    let dropDown = DropDown()
    @IBOutlet weak var categoryPickView: EffectView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var priceTF: UITextField!
    
    
    @IBOutlet weak var pickedImage1: UIImageView!
    @IBOutlet weak var pickedImage2: UIImageView!
    @IBOutlet weak var pickedImage3: UIImageView!
    @IBOutlet weak var pickedImage4: UIImageView!
    
    
    var imageUrl1 = "";
    var imageUrl2 = "";
    var imageUrl3 = "";
    var imageUrl4 = "";
    
    var pickImageNumber: Int = 1;
    
    
    var categories: [String] = [] {
        didSet {
            self.dropDown.dataSource = categories
            self.dropDown.reloadAllComponents()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.categories = AppCommon.categories
        configureCategory()
    }
    
    func configureCategory() {
        dropDown.anchorView = self.categoryPickView
        dropDown.selectionAction = { [](index: Int, item: String) in
            self.categoryLabel.text = item;
        }
        
        categoryPickView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDropDown)));
    }
    @objc func showDropDown() {
        self.dropDown.show()
    }

    @IBAction func handleAddImage1(_ sender: Any) {
        self.pickImageNumber = 1;
        self.handleImageSelect()
    }
    
    @IBAction func handleAddImage2(_ sender: Any) {
        self.pickImageNumber = 2;
        self.handleImageSelect()
    }
    @IBAction func handleAddImage3(_ sender: Any) {
        self.pickImageNumber = 3;
        self.handleImageSelect()
    }
    @IBAction func handleAddImage4(_ sender: Any) {
        self.pickImageNumber = 4;
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
        
        actionController.popoverPresentationController?.sourceView = self.pickedImage1
        actionController.popoverPresentationController?.sourceRect = self.pickedImage1.bounds
        
        present(actionController, animated: true, completion: nil)
    }
    
    
    @IBAction func handleUploadThing(_ sender: Any) {
        if titleTF.text == "" {
            self.view.makeToast(NSLocalizedString("Please input the title first", comment: ""))
            return;
        }
        if descriptionTV.text == "" {
            self.view.makeToast(NSLocalizedString("Please input the description", comment: ""))
            return;
        }
        if categoryLabel.text == "" {
            self.view.makeToast(NSLocalizedString("Please select the category", comment: ""))
            return;
        }
        if priceTF.text == "" {
            self.view.makeToast(NSLocalizedString("Please input the price", comment: ""))
            return;
            if let price = Double(priceTF.text!) {
                if (price <= 0) {
                    self.view.makeToast(NSLocalizedString("The price must be greater than 0", comment: ""))
                    return;
                }
            } else {
                self.view.makeToast(NSLocalizedString("Please input the valid price", comment: ""))
                return;
            }
        }

        DBProvider.shared.thingsRef.childByAutoId().setValue([
            "title": self.titleTF.text ?? "",
            "category": self.categoryLabel.text,
            "description": self.descriptionTV.text ?? "",
            "price": Double(self.priceTF.text!) ?? 0,
            "ownerId": User.currentUser.id,
            "imageUrl1": self.imageUrl1,
            "imageUrl2": self.imageUrl2,
            "imageUrl3": self.imageUrl3,
            "imageUrl4": self.imageUrl4,
            "selled": false,
        ]) { (error, snapshot) in
            DispatchQueue.main.async {
                self.view.makeToast(NSLocalizedString("Successfully registered!", comment: ""))
                
                if User.currentUser.currentThing == "" {
                    DBProvider.shared.userRef.child(User.currentUser.id!).updateChildValues([
                        "currentThing": snapshot.key
                    ])
                    User.currentUser.currentThing = snapshot.key
                }
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
//        let transition = Transitions.getRightToLeftVCTransition()
//        transition.type = kCATransitionReveal
//        //        view.layer.add(transition, forKey: kCATransition)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
   

}

extension AddThingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                imagePicked(image: selectedImage)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePicked(image: UIImage) {
        let imageName = NSUUID().uuidString + ".jpg"
        var ref = DBProvider.shared.thingsImageStorage.child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
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
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
                DispatchQueue.main.async {
                    switch self.pickImageNumber {
                    case 1:
                        self.pickedImage1.image = image
                        self.imageUrl1 = imageUrl
                        break;
                    case 2:
                        self.pickedImage2.image = image
                        self.imageUrl2 = imageUrl
                        break;
                    case 3:
                        self.pickedImage3.image = image
                        self.imageUrl3 = imageUrl
                        break;
                    case 4:
                        self.pickedImage4.image = image
                        self.imageUrl4 = imageUrl
                        break;
                    default:
                        break;
                    }
                }
            })
        }
    }
}










