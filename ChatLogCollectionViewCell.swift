//
//  ChatLogCollectionViewCell.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 7/8/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit

class ChatLogCollectionViewCell: UICollectionViewCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let bubbleMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleMessageWidthAnchor: NSLayoutConstraint?
    var bubbleMessageRightAnchor: NSLayoutConstraint?
    var bubbleMessageLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleMessageView)
        addSubview(messageTextView)
        
        //constraints for bubbleMessageView
        
        bubbleMessageRightAnchor = bubbleMessageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleMessageRightAnchor?.isActive = true
        bubbleMessageLeftAnchor = bubbleMessageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleMessageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleMessageWidthAnchor = bubbleMessageView.widthAnchor.constraint(equalToConstant: 200)
        bubbleMessageWidthAnchor?.isActive = true
        bubbleMessageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //constraints for messageTextView
        messageTextView.leftAnchor.constraint(equalTo: bubbleMessageView.leftAnchor, constant: 8).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: bubbleMessageView.rightAnchor).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
