//
//  AwarenessCell.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 9/15/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Swiftstraints

class AwarenessCell : UICollectionViewCell {
    
    var awarenessViewController: AwarenessViewController?
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "userpic")
        image.layer.masksToBounds = true
        image.contentMode = .ScaleAspectFill
        image.userInteractionEnabled = true
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addConstraints(imageView.leftAnchor == self.leftAnchor,
                       imageView.widthAnchor == self.widthAnchor,
                       imageView.topAnchor == self.topAnchor,
                       imageView.heightAnchor == self.heightAnchor)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
