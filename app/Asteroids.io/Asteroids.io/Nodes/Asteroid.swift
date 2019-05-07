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
    
    init(owner: String, id: String, transform: NetworkTransform, data: JSON) {
        size = Size(rawValue: data["size"] as! String)!
        direction = Asteroid.calculateDirection(side: data["side"] as! Int, angle: data["angle"] as! Double)
        print(direction)
        super.init(owner: owner, id: id, transform: transform)
        setupNode(data: data)
        
        print("side: \(data["side"] as! Int), direction: \(direction), position: \(node!.position)")
    }
    
    static func calculateDirection(side: Int, angle: Double) -> CGVector {
        let x: Double!
        let y: Double!
        let theta = Double(DegreesToRadians) * angle
        switch side {
        case 0:
            x = 1.0; y = 0.0
            break
        case 1:
            x = 0.0; y = -1.0
            break
        case 2:
            x = -1.0; y = 0.0
            break
        case 3:
            x = 0.0; y = 1.0
            break
        default:
            x = 0.0; y = 0.0
        }
        return CGVector(dx: x * cos(theta) - y * sin(theta), dy: x * sin(theta) + y * cos(theta))
    }
    
    static func calculatePosition(side: Int, offset: Double) -> CGPoint {
        let x: Double!
        let y: Double!
        switch side {
        case 0:
            x = -sceneWidth / 2; y = sceneHeight / 2 * offset
            break
        case 1:
            x = sceneWidth / 2 * offset; y = sceneHeight / 2
            break
        case 2:
            x = sceneWidth / 2; y = sceneHeight / 2 * offset
            break
        case 3:
            x = sceneWidth / 2 * offset; y = -sceneHeight / 2
            break
        default:
            x = 0.0; y = 0.0
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func setupNode(data: JSON) {
        let sprite = SKTexture(imageNamed: size.rawValue)
        asteroid = SKSpriteNode(texture: sprite, color: UIColor.clear, size: sprite.size())
        asteroid.position = Asteroid.calculatePosition(side: data["side"] as! Int, offset: data["offset"] as! Double)
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width / 2)
        asteroid.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.all & ~PhysicsCategory.asteroid
        asteroid.physicsBody?.collisionBitMask = PhysicsCategory.none
        asteroid.physicsBody?.affectedByGravity = false
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
