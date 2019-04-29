//
//  Laser.swift
//  Asteroids.io
//
//  Created by Tony on 4/25/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKShapeNode {
    
    override init() {
        super.init()
        let rect = CGRect(x: 0, y: 0, width: 20, height: 100)
        self.path = CGPath(rect: rect, transform: nil)
        self.fillColor = UIColor.orange
        self.strokeColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
