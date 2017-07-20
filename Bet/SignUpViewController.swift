//
//  SignUpViewController.swift
//  Bet
//
//  Created by Madison Heck on 7/19/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordAgain: UITextField!
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        let storage = FIRStorage.storage().reference(forURL: "gs://betme-cba6a.appspot.com")
        
        ref = FIRDatabase.database().reference()
        userStorage = storage.child("users")
        
    }
    
    
    @IBAction func selectImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePicture.image = image
            finishedButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finishedButtonPressed(_ sender: Any) {
        
        guard email.text != "", username.text != "", password.text != "", passwordAgain.text != "" else { return }
        
        if password.text == passwordAgain.text {
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.username.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, error2) in
                        if error2 != nil {
                            print(error2?.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, err) in
                            if err != nil {
                                print(err!.localizedDescription)
                            }
                            
                            
                            if let url = url {
                                
                                let userInfo: [String : Any] = ["uid" :user.uid,
                                                                "username" : self.username.text!,
                                                                "urlToImage" : url.absoluteString]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                            }
                        })
                    })
              //      self.performSegue(withIdentifier: "signUpToLogIn", sender: nil)
                    uploadTask.resume()
                }
            })
        } else {
            print("Password does not match")
        }
        
    }

}
