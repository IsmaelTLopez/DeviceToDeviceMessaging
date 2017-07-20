//
//  ChatLogController.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 6/30/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var separaterView: UIView!
    @IBOutlet weak var containerInputView: UIView!
    @IBOutlet weak var chatTextField: UITextField!
    var messages = [Message]()
    var chatLogUser:OurUser?{
        didSet{
            self.navigationItem.title = chatLogUser?.name
            observeMessages()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessageInputComponents()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatLogCollectionViewCell.self, forCellWithReuseIdentifier: "collectionMessage")
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:AnyObject] else{
                    return
                }
                let message = Message()
                message.setValuesForKeys(dictionary)
                if message.returnChatPartnerId() == self.chatLogUser?.id{
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @IBAction func handleSend(_ sender: UIButton) {
        let databaseRef = Database.database().reference().child("messages")
        let childRef = databaseRef.childByAutoId()
        guard let message = chatTextField.text else{
            return
        }
        if message != "" {
            if let toId = chatLogUser?.id, let fromId = Auth.auth().currentUser?.uid {
                let timestamp = Int(Date().timeIntervalSince1970) as NSNumber
                       let values = ["text":message, "toId":toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
                childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                    let messageId = childRef.key
                    userMessagesRef.updateChildValues([messageId:1])
                    let recipientMessagesRef = Database.database().reference().child("user-messages").child(toId)
                    recipientMessagesRef.updateChildValues([messageId:1])
                })
            }
            chatTextField.text = ""
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionMessage", for: indexPath) as! ChatLogCollectionViewCell
        let message = messages[indexPath.item]
        cell.messageTextView.text = message.text
        setupCell(cell: cell, message:message)
        cell.bubbleMessageWidthAnchor?.constant = approximateTextViewSize(text: message.text!).width + 30
        return cell
    }
    
    private func setupCell(cell: ChatLogCollectionViewCell, message: Message) {
        if message.fromId == Auth.auth().currentUser?.uid {
            //your message
            cell.bubbleMessageView.backgroundColor = UIColor.blue
            cell.messageTextView.textColor = UIColor.white
            cell.bubbleMessageLeftAnchor?.isActive = false
            cell.bubbleMessageRightAnchor?.isActive = true
            
        } else {
            //partner message
            cell.bubbleMessageView.backgroundColor = UIColor.lightGray
            cell.messageTextView.textColor = UIColor.black
            cell.bubbleMessageRightAnchor?.isActive = false
            cell.bubbleMessageLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 50
        if let text = messages[indexPath.item].text {
            height = approximateTextViewSize(text: text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func approximateTextViewSize(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 900)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func setupMessageInputComponents(){
        view.addSubview(containerInputView)
        view.addSubview(separaterView)
        
        //constraints for containerInputView
        containerInputView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerInputView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerInputView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //constraints for separaterView
        separaterView.leftAnchor.constraint(equalTo: containerInputView.leftAnchor).isActive = true
        separaterView.bottomAnchor.constraint(equalTo: containerInputView.topAnchor).isActive = true
        separaterView.widthAnchor.constraint(equalTo: containerInputView.widthAnchor).isActive = true
        separaterView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}
