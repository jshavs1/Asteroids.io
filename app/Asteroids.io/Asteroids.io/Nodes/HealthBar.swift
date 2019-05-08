//
//  HealthBar.swift
//  Asteroids.io
//
//  Created by Tony on 5/7/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar: SKSpriteNode {
    
    var health: CGFloat {
        didSet {
            xScale = max(self.health, 0)
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        health = 1.0
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        health = 1.0
        super.init(coder: aDecoder)
    }
    
}
