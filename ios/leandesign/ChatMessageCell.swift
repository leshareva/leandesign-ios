//
//  ChatMessageCell.swift
//  gamechat
//
//  Created by Sladkikh Alexey on 8/17/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Swiftstraints

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController: ChatViewController?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Some Sample Text"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFontOfSize(16)
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.whiteColor()
        tv.editable = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "dog")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .ScaleAspectFill
        return image
    }()
    
   lazy var messageImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .ScaleAspectFill
        image.userInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return image
    }()
    
    
    let awarenessView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.editable = false
        view.font = UIFont.systemFontOfSize(16)
         view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    let iconOfEvent: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "psd")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
  
        //Pro Tip: don't perform a lot of custom logic inside of a view class
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomInForImageView(imageView)
            
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        bubbleView.addSubview(messageImageView)
        bubbleView.addSubview(awarenessView)
        bubbleView.addSubview(iconOfEvent)
        
        messageImageView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor).active = true
        messageImageView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        messageImageView.widthAnchor.constraintEqualToAnchor(bubbleView.widthAnchor).active = true
        messageImageView.heightAnchor.constraintEqualToAnchor(bubbleView.heightAnchor).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(32).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
        bubleViewRightAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8)
        bubleViewRightAnchor?.active = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8)
        
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthAnchor?.active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        textView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        textView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
       
        
        
        bubbleView.addConstraints(
                        iconOfEvent.widthAnchor == 30,
                        iconOfEvent.heightAnchor == 30,
                        iconOfEvent.topAnchor == bubbleView.topAnchor + 8,
                        iconOfEvent.leftAnchor == bubbleView.leftAnchor + 8,
                        awarenessView.leftAnchor == iconOfEvent.rightAnchor,
                        awarenessView.topAnchor == bubbleView.topAnchor,
                        awarenessView.rightAnchor == bubbleView.rightAnchor,
                        awarenessView.heightAnchor == bubbleView.heightAnchor
        )
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

   
    
}


