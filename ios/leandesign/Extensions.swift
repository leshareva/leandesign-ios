//
//  Extensions.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 8/10/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit

let imageCashe = NSCache()

extension UIImageView {
    
    func loadImageUsingCashWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cashe for image first
        if let cashedImage = imageCashe.objectForKey(urlString) as? UIImage {
            self.image = cashedImage
            return
        }
        
        //otherwise fire off a new download
        
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCashe.setObject(downloadedImage, forKey: urlString)
                    
                    self.image = downloadedImage
                }
                
                
            })
            
            
        }).resume()
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}





extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

