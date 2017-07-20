//
//  MessagesTableViewCell.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 7/1/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var message:Message?{
        didSet{
            
            messageLabel?.text = message?.text
            if let seconds = message?.timestamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timestampLabel.text = dateFormatter.string(from: timeStampDate)
            }
            
            setupNameAndProfileImage()
            
        }
    }
    
    private func setupNameAndProfileImage(){
        
        
        if let id = message?.returnChatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.nameLabel?.text = dictionary["name"] as? String
                    if let profileImageURL = dictionary["profileImageURL"] as? String{
                        self.profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageURL)
                    }
                }
                
            }, withCancel: nil)
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
