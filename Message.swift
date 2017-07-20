//
//  Message.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 7/1/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId:String?
    var text:String?
    var timestamp:NSNumber?
    var toId:String?
    
    func returnChatPartnerId() ->String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        }else{
            return fromId
        }
    }

}
