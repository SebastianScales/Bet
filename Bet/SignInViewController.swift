//
//  SignInViewController.swift
//  Bet
//
//  Created by Madison Heck on 7/18/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 1 {
            self.performSegue(withIdentifier: "signInToSignUpSegue",    sender: nil)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "", passwordTextField.text != "" {
            
            if segmentControl.selectedSegmentIndex == 0 //Login User
            {
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    if user != nil {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                        
                        self.present(vc, animated:true, completion: nil)
                        
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            print(myError)
                        }
                        else
                        {
                            print("ERROR")
                        }
                    }
                })
            }
            else //Sign up user
            {
                
                self.performSegue(withIdentifier: "signInToSignUpSegue", sender: nil)
                
            }
        }
    }


}
