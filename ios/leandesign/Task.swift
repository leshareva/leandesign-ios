//
//  Task.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 8/11/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import DigitsKit

class Task: NSObject {
    
    var fromId: String?
//    var taskImageURL: String?
    var text: String?
//    var timestamp: NSNumber?
    var toId: String?
    var timestamp: NSNumber?
    var status: String?
    var taskId: String?
    var imageUrl: String?
    var price: NSNumber?
    var timeState: NSNumber?
    var phone: String?
    var awareness: String?
    var company: String?
    var rate: String?
    
    func chatPartnerId() -> String? {
        return fromId == Digits.sharedInstance().session()?.userID ? toId : fromId
    }
}


