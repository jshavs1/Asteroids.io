//
//  Spaceship.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class Spaceship: SKSpriteNode {
    let smoke: SKEmitterNode
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.smoke = SKEmitterNode(fileNamed: "SmokeParticle.sks")!
        self.smoke.position = CGPoint(x: 0, y: -texture.size().height / 2)
        self.smoke.zPosition = -1
        self.smoke.zRotation = 180 * CGFloat(DegreesToRadians)
        self.smoke.particleBirthRate = 0
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        addChild(self.smoke)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
