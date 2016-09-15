//
//  ConceptViewController.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 9/15/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Swiftstraints
import Firebase

class ConceptViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    let ref = FIRDatabase.database().reference()
    let customCellIdentifier = "customCellIdentifier"
    
    
    let acceptView = AcceptView()
    
    var task: Task? {
        didSet {
           observeConcept()
        }
    }
    
    var concepts = [Concept]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        
        self.acceptView.acceptTaskButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.acceptConcept)))
        
        
        
  
    }
    
    func setupView() {
        
        if let taskId = self.task?.taskId {
        ref.child("tasks").child(taskId).child("concept").observeEventType(.Value, withBlock: { (snapshot) in
            let status = snapshot.value!["status"] as? String
            if status != "accept" {
                self.acceptView.acceptedLabel.text = "Согласовать"
                self.acceptView.acceptTaskButtonView.userInteractionEnabled = true
            } else {
                self.acceptView.acceptTaskButtonView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
            }
            
            }, withCancelBlock: nil)
        }
        self.view.addSubview(acceptView)
        acceptView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(acceptView.widthAnchor == self.view.widthAnchor,
                                 acceptView.bottomAnchor == self.view.bottomAnchor,
                                 acceptView.heightAnchor == 50)
      
    }
    
    func observeConcept() {
        if let taskId = self.task?.taskId {
            ref.child("tasks").child(taskId).child("concept").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : AnyObject] else {
                    return
                }
                self.concepts.append(Concept(dictionary: dictionary))
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })
                
                }, withCancelBlock: nil)
        }
    }
    
    
    func acceptConcept() {
    
        let values : [String: AnyObject] = ["status": "accept"]
        if let taskId = task!.taskId {
            ref.child("tasks").child(taskId).child("concept").updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                self.acceptView.acceptedLabel.text = "Согласовано"
                self.acceptView.acceptTaskButtonView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
                
            }
        }
        
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(customCellIdentifier, forIndexPath: indexPath) as! CustomCell
        
        let concept = concepts[indexPath.item]
        if let imageUrl = concept.imgUrl {
            cell.imageView.loadImageUsingCashWithUrlString(imageUrl)
        }
        
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return concepts.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 200)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        setupView()
    }
    
}

class CustomCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    func setupView() {
        
        backgroundColor = UIColor.whiteColor()
        addSubview(imageView)
        addConstraints(imageView.leftAnchor == self.leftAnchor,
                            imageView.widthAnchor == self.widthAnchor,
                            imageView.topAnchor == self.topAnchor,
                            imageView.heightAnchor == self.heightAnchor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
