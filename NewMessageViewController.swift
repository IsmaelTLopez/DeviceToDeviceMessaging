//
//  NewMessageViewController.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 6/27/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messagesController : MessagesViewController?
    
    var users = [OurUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friends"
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchUser()

    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = OurUser()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                DispatchQueue.main.async(){
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }

    @IBOutlet weak var tableView: UITableView!
  
    @IBAction func cancelMessage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "newMessage", for: indexPath) as! NewMessageTableViewCell
        cell.cellTextLabel?.text = user.name
        if let profileImageURL = user.profileImageURL{
            cell.profileImage.loadImageUsingCacheWithURLString(urlString: profileImageURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        messagesController?.goToChatLogForUser(user: user)
        dismiss(animated: true, completion: nil)
    }

}
