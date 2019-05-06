//
//  Laser.swift
//  Asteroids.io
//
//  Created by Tony on 4/25/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class Laser: NetworkObject {
    
    var node: SKShapeNode
    var direction: CGVector
    var velocity: CGVector!
    static let speed: CGFloat = 2000
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        self.node = SKShapeNode()
        self.direction = CGVector.zero
        self.velocity = CGVector.zero
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
    }
    
    init(owner: String, id: String, transform: NetworkTransform, direction: CGVector){
        self.node = SKShapeNode()
        self.direction = direction
        self.velocity = CGVector(dx: direction.dx * Laser.speed * CGFloat(deltaTime), dy: direction.dy * Laser.speed * CGFloat(deltaTime))
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
        
    }
    
    func setupNode() {
        let rect = CGRect(x: self.transform.x, y: self.transform.y, width: 20, height: 100)
        node.position = transform.position
        node.path = CGPath(rect: rect, transform: nil)
        node.physicsBody = SKPhysicsBody(rectangleOf: rect.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.categoryBitMask = isMine ? playerCategoryMask : enemyCategoryMask
        node.physicsBody!.contactTestBitMask = isMine ? enemyCategoryMask : playerCategoryMask
        node.fillColor = UIColor.orange
        node.strokeColor = UIColor.clear
    }
    
    func shoot() {
        
        guard node.scene != nil else { return }
        let action = SKAction.move(by: self.velocity, duration: deltaTime)
        node.run(action) {
            self.shoot()
        }
    }
    
    //override func transformWillChange(newTransform: NetworkTransform) {
   //     let action = SKAction.move(to: newTransform.position, duration: deltaTime)
    //    node.run(action)
    //}
}
