//
//  AwarenessViewController.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 9/13/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Swiftstraints
import Firebase


class AwarenessViewController: UIViewController {

    static let blueColor = UIColor(r: 48, g: 140, b: 229)
    var task: Task?
    var message: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let awarenessView: UITextView = {
       let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFontOfSize(16)
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.blackColor()
        return tv
    }()
    
    let priceLabel: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFontOfSize(26)
        return tv
    }()
    
    lazy var acceptTaskButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 172, g: 223, b: 61)
        return view
    }()
    
    lazy var acceptButton: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(acceptAwareness)))
        view.userInteractionEnabled = true
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(r: 172, g: 223, b: 61)
        return view
    }()
    
    
    let acceptButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    let acceptedLabel: UILabel = {
        let label = UILabel()
        label.text = "Согласовано"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    
    func setupView(message: Message) {
        let awareness = message.awareness
        
        if awareness != nil {
            self.view.addSubview(awarenessView)
            self.view.addSubview(acceptTaskButtonView)
            self.view.addSubview(priceLabel)
            self.view.addSubview(acceptedLabel)
            
            self.view.addConstraints("H:|-8-[\(awarenessView)]-8-|", "H:|-8-[\(priceLabel)]-8-|")
            self.view.addConstraints("V:|[\(awarenessView)][\(priceLabel)]")
            
            self.view.addConstraints(awarenessView.heightAnchor == self.view.heightAnchor - 90)
            
            acceptTaskButtonView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
            acceptTaskButtonView.heightAnchor.constraintEqualToConstant(50).active = true
            acceptTaskButtonView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
            acceptTaskButtonView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
            
            acceptTaskButtonView.addSubview(acceptButton)
            
            acceptButton.centerYAnchor.constraintEqualToAnchor(acceptTaskButtonView.centerYAnchor).active = true
            acceptButton.centerXAnchor.constraintEqualToAnchor(acceptTaskButtonView.centerXAnchor).active = true
            acceptButton.widthAnchor.constraintEqualToAnchor(acceptTaskButtonView.widthAnchor, constant: -26).active = true
            acceptButton.heightAnchor.constraintEqualToAnchor(acceptTaskButtonView.heightAnchor, constant: -16).active = true
            
            acceptButton.addSubview(acceptButtonLabel)
            acceptButton.addConstraints("V:|[\(acceptButtonLabel)]|")
            acceptButton.addConstraints(
                acceptButtonLabel.heightAnchor == acceptButton.heightAnchor,
                acceptButtonLabel.centerXAnchor == acceptButton.centerXAnchor)

            self.view.addConstraints(acceptedLabel.centerXAnchor == acceptTaskButtonView.centerXAnchor,
                                     acceptedLabel.centerYAnchor == acceptTaskButtonView.centerYAnchor)
        } else {
            print("Это не понимание задачи")
        }
        
    }
    
    
    func acceptAwareness() {
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let taskId = task?.taskId {
            let taskRef = FIRDatabase.database().reference().child("tasks").child(taskId)
        
            taskRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                guard let status = snapshot.value!["status"] as? String else {
                    return
                }
                
                if status == "awareness" {
                    self.acceptedLabel.hidden = true
                } else {
                   self.acceptButton.hidden = true
                    self.acceptButtonLabel.hidden = true
                    self.acceptedLabel.hidden = false
                    self.acceptTaskButtonView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
                }
                
                guard let minPrice = snapshot.value!["minPrice"] as? NSNumber else {
                    return
                }
                guard let maxPrice = snapshot.value!["maxPrice"] as? NSNumber else {
                    return
                }
                
                self.priceLabel.text = String(minPrice) + " — " + String(maxPrice) + "₽"
                
                }, withCancelBlock: nil)
            
            taskRef.child("awareness").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let text = snapshot.value!["text"] as? String {
                    self.awarenessView.text = text
                }
                }, withCancelBlock: nil)
        
        }
        
      
        
        
    }

}
