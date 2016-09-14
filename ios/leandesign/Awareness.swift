//
//  Message.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 8/17/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Firebase
import DigitsKit

class Awareness: NSObject {
   
    var imgUrl: String?
    
    
    init(dictionary: [String: AnyObject]) {
        super.init()
       
        imgUrl = dictionary["imgUrl"] as? String
        
    }
    
    
}

