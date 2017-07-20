//
//  NewMessageTableViewCell.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 6/27/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 33
        profileImage.layer.masksToBounds = true
    }
    
    
    @IBOutlet var cellTextLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
