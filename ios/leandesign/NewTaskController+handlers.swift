//
//  NewTaskController+handlers.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 8/11/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Firebase
import DigitsKit


extension NewTaskController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    func handleSelectAttachImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
       
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            attachImageView.image = selectedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    

    
    func addNewTask() {
        
        
        guard let fromId = Digits.sharedInstance().session()?.userID else {
            return
        }
        
        guard let taskText = taskTextField.text where !taskText.isEmpty else {
            return
        }
        
        
        
        let ref = FIRDatabase.database().reference().child("tasks")
        let postRef = ref.childByAutoId()
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let taskId = postRef.key
        let status = "На оценке"
        let toId = "designStudio"
        let phone = Digits.sharedInstance().session()?.phoneNumber
        let company = "Вот такие пироги"
        let price = 0
        let timeState = 0
        let image = attachImageView.image
        let imageName = NSUUID().UUIDString
        let imageref = FIRStorage.storage().reference().child("task_image").child(imageName)
        
//        if let uploadData = UIImageJPEGRepresentation(image!, 0.2) {
//            imageref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil {
//                    print("Faild upload image:", error)
//                    return
//                }
        
//                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    let values : [String : AnyObject] = ["awareness": "", "fromId": fromId, "text": taskText, "taskId": taskId, "timestamp": timestamp, "status": status, "toId": toId, "price": price, "timeState": timeState, "phone": phone!, "company": company, "rate": 0.5]
                    
                    postRef.setValue(values)
                    postRef.updateChildValues(values) { (error, ref) in
                        if error != nil {
                            print(error)
                            return
                        }
                        let userTaskRef = FIRDatabase.database().reference().child("user-tasks").child(fromId)
                        let taskId = postRef.key
                        userTaskRef.updateChildValues([taskId: 1])
                        
//                        let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-tasks").child(toId)
//                        recipientUserMessagesRef.updateChildValues([taskId: 1])
                    }
                    
//                }
                let messageRef = FIRDatabase.database().reference().child("tasks").child(taskId).child("messages")
                let messageРostRef = messageRef.childByAutoId()
                let messageValues = ["text": taskText, "taskId": taskId, "timestamp": timestamp, "fromId": fromId, "toId": toId]
                messageРostRef.updateChildValues(messageValues) { (error, ref) in
                    if error != nil {
                        print(error)
                        return
                    }
                
//                }
                
                self.sendTaskImageToChat()
//            })
        }
     
        
         dismissViewControllerAnimated(true, completion: nil) 

  
    }
    
    func sendTaskImageToChat() {
        
    }
    
    private func registerTaskInDatabaseWithUID(uid: String, values: [String: AnyObject]) {
    
        
        
    }
    
    
    
    
    
    
}
