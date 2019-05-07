//
//  DesignableView.swift
//  Asteroids.io
//
//  Created by Tony on 5/7/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
