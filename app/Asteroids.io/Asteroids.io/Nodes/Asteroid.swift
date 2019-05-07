//
//  Asteroid.swift
//  Asteroids.io
//
//  Created by Tony on 5/6/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class Asteroid: NetworkObject {
    var asteroid: SKSpriteNode! {
        get { return (node as! SKSpriteNode)}
        set { self.node = newValue }
    }
    let speed: CGFloat = 300
    let direction: CGVector
    var velocity: CGVector {
        get {
            return CGVector(dx: direction.dx * speed * CGFloat(deltaTime), dy: direction.dy * speed * CGFloat(deltaTime))
        }
    }
    var size: Size
 
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        direction = CGVector.zero
        size = Size.small
        super.init(owner: owner, id: id, transform: transform)
    }
    
    init(owner: String, id: String, transform: NetworkTransform, size: Size, position: CGPoint, direction: CGVector) {
        self.size = size
        self.direction = direction
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
        asteroid.position = position
    }
    
    func setupNode() {
        let sprite = SKTexture(imageNamed: size.rawValue)
        asteroid = SKSpriteNode(texture: sprite, color: UIColor.clear, size: sprite.size())
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width / 2)
        asteroid.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        asteroid.physicsBody?.contactTestBitMask = ~PhysicsCategory.asteroid
        asteroid.physicsBody?.collisionBitMask = PhysicsCategory.none
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func launch() {
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.random(min: -Double.pi * 0.2, max: Double.pi * 0.2)), duration: deltaTime)
        
        asteroid.run(SKAction.repeatForever(rotate))
        move()
    }
    
    func move() {
        let move = SKAction.moveBy(x: velocity.dx, y: velocity.dy, duration: deltaTime)
        
        asteroid.run(move) {
            self.transform.position = self.asteroid.position
            self.move()
        }
    }
    
    override func transformWillChange(newTransform: NetworkTransform) {
        if (!(self.node!.scene!.intersects(self.node!))) {
            NetworkManager.destroy(object: self)
        }
    }
    
}
