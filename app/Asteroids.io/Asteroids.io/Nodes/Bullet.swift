//
//  Bullet.swift
//  Asteroids.io
//
//  Created by user915547 on 5/4/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    
    init() {
        
        let texture = SKTexture(imageNamed: "bolt")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        //super.init(imageNamed: "player")
        //self.imageNamed = "player"       //self.
        //let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        //self.path = CGPath(rect: rect, transform: nil)
        
        //self.fillColor = UIColor.blue
        //self.strokeColor = UIColor.clear
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
