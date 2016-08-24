//
//  TaskInfoController.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 8/13/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Firebase

class TaskInfoController: UIViewController {
  
    
     var tasks = [Task]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
       aboutTaskSetup()
       
    }
    
    let taskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.redColor()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let taskLabel: UILabel = {
        let textView = UILabel()
        let tasks = Task()
        textView.text = tasks.text
        textView.backgroundColor = UIColor.greenColor()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func aboutTaskSetup() {
        
        view.addSubview(taskImageView)
        view.addSubview(taskLabel)
        
        taskImageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        taskImageView.heightAnchor.constraintEqualToConstant(200).active = true
        taskImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        taskImageView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        
        taskLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -16).active = true
        taskLabel.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        taskLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 16).active = true
        taskLabel.topAnchor.constraintEqualToAnchor(taskImageView.bottomAnchor, constant: 16).active = true

        
    }

}
