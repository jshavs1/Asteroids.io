//
//  DesignableButton.swift
//  Asteroids.io
//
//  Created by Tony on 5/7/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = frame.size.height / 2
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}
