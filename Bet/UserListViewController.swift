//
//  UserListViewController.swift
//  Bet
//
//  Created by Madison Heck on 7/19/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var userList: UITableView!
    
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        retrieveUsers()
    }
    
    func retrieveUsers() {
        
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.user.removeAll()
            for (_ , value) in users {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser?.uid {
                        let userToShow = User()
                        if let username = value["username"] as? String, let imagePath = value["urlToImage"] as? String {
                                userToShow.username = username
                                userToShow.imagePath = imagePath
                                userToShow.userID = uid
                                self.user.append(userToShow)
                        }
                    }
                }
            }
            
            self.userList.reloadData()
        })
        ref.removeAllObservers()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userList.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text! = self.user[indexPath.row].username
        cell.userID = self.user[indexPath.row].userID
        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
    }

}


extension UIImageView {
    func downloadImage(from imgURL: String!) {
        
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        task.resume()
    
    }
}



