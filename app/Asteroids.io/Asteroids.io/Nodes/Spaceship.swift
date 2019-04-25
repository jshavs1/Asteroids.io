//
//  Spaceship.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class Spaceship: SKShapeNode {
    
    override init() {
        super.init()
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.path = CGPath(rect: rect, transform: nil)
        
        self.fillColor = UIColor.blue
        self.strokeColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
