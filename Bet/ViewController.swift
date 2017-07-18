//
//  ViewController.swift
//  Bet
//
//  Created by Madison Heck on 7/16/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Bet1Button: UIButton!
    @IBOutlet weak var Bet2Button: UIButton!
    
    @IBOutlet weak var Bet1Description: UITextField!
    @IBOutlet weak var Bet2Description: UITextField!

    @IBOutlet weak var mainDisplay: UITextField!
    
    var myList:[String] = []
    
    var ref:FIRDatabaseReference?
    
    var handle:FIRDatabaseHandle?


    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ref = FIRDatabase.database().reference()

        
        handle = ref?.child("list").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String {
                self.myList.append(item)
                self.tableView.reloadData()
            }
        
        })
    }
   
    @IBAction func bet1Pressed(_ sender: Any) {
    
        if Bet1Button.titleColor(for: .normal) != UIColor.green {
        Bet1Button.setTitle("Accepted", for: .normal)
        Bet1Button.setTitleColor(UIColor.green, for: .normal)
            
            if Bet1Description.text != "" {
                ref?.child("list").childByAutoId().setValue(Bet1Description.text)
                Bet1Description.text = ""
            }
        }
        else {
            Bet1Button.setTitle("Bet", for: .normal)
            Bet1Button.setTitleColor(UIColor.red, for: .normal)
        }
        
        
    }
    
    
    @IBAction func Bet2Pressed(_ sender: Any) {
        
        if Bet2Button.titleColor(for: .normal) != UIColor.green {
        Bet2Button.setTitle("Accepted", for: .normal)
        Bet2Button.setTitleColor(UIColor.green, for: .normal)
            
            
            if Bet2Description.text != "" {
                ref?.child("list").childByAutoId().setValue(Bet2Description.text)
                Bet2Description.text = ""
            }
        }
        else {
            Bet2Button.setTitle("Bet", for: .normal)
            Bet2Button.setTitleColor(UIColor.red, for: .normal)
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    
    
    
    

    @IBAction func betFeedPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "betFeedSegue", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

