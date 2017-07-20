//
//  LoginViewController.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 6/25/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginRegisterSegmentControl: UISegmentedControl!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginRegisterButton: UIButton!
    
    var messagesController:MessagesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet var testImage: UIImageView!
    
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else{
            print("Invalid Inputs")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            let imageID = NSUUID().uuidString
            let storageReference = Storage.storage().reference().child("profile_images").child("\(imageID).jpg")
            
            if let profileImage = self.testImage.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
            
            //if let uploadData = UIImagePNGRepresentation(self.testImage.image!){
                storageReference.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                        let values = ["name" : name, "email" : email, "profileImageURL" : profileImageURL] as [String : AnyObject]
                        self.registerUserIntoDatabaseWith(uid: uid, values: values)
                        
                    }
                    
                    
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWith(uid: String, values: [String : AnyObject]){
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, refference) in
            if err != nil {
                print(err!)
                return
            }
            
            let user = OurUser()
            //can crash if user value keys don't match firebase keys
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            self.dismiss(animated: true)
            
        })
    }
    

    @IBAction func handleRegisterLogin(_ sender: UIButton) {
        if loginRegisterSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    

    
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            print("Invalid Inputs")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            
            self.messagesController?.fetchUserValuesAndSetupNavTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleLoginRegisterState(_ sender: UISegmentedControl) {
        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Handle height for content input stackView
        stackViewHeightConstraint.constant = sender.selectedSegmentIndex == 0 ? 60 : 90
        nameHeightConstraint.constant = sender.selectedSegmentIndex == 0 ? 0 : 30
    }
    
    @IBAction func handleSelectProfileImage(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker:UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            testImage.image = selectedImage 
        }
        dismiss(animated: true, completion: nil)
    }

}
