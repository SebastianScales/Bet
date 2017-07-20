//
//  BetFeedViewController.swift
//  Bet
//
//  Created by Madison Heck on 7/17/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class BetFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newBetTextField: UITextField!
    @IBOutlet weak var betButton: UIButton!
    
    var myList:[String] = []
    
    var ref:FIRDatabaseReference?
    
    var handle:FIRDatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        
        handle = ref?.child("betList").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String {
                self.myList.append(item)
                self.tableView.reloadData()
            }
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func newBetPressed(_ sender: Any) {
        if newBetTextField.text != "" {
            ref?.child("betList").childByAutoId().setValue(newBetTextField.text)
            newBetTextField.text = ""
        }
    }
    

    @IBAction func logoutButtonPressed(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    
    

}
