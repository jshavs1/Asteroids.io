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
    
    var direction: CGVector
    var velocity: CGVector!
    static let speed: CGFloat = 2000
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        self.direction = CGVector.zero
        self.velocity = CGVector.zero
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
    }
    
    init(owner: String, id: String, transform: NetworkTransform, direction: CGVector){
        self.direction = direction
        self.velocity = CGVector(dx: direction.dx * Laser.speed * CGFloat(deltaTime), dy: direction.dy * Laser.speed * CGFloat(deltaTime))
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
        
    }
    
    func setupNode() {
        self.node = SKShapeNode()
        guard let node = self.node as? SKShapeNode else { return }
        let rect = CGRect(x: 0, y: 0, width: 20, height: 100)
        node.position = transform.position
        node.zRotation = atan2(direction.dy, direction.dx) + CGFloat(90 * DegreesToRadians)
        node.path = CGPath(rect: rect, transform: nil)
        node.physicsBody = SKPhysicsBody(rectangleOf: rect.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.categoryBitMask = isMine ? PhysicsCategory.playerProjectile : PhysicsCategory.enemyProjectile
        node.physicsBody!.contactTestBitMask = isMine ? PhysicsCategory.enemy | PhysicsCategory.asteroid :
                                                        PhysicsCategory.player | PhysicsCategory.asteroid
        node.physicsBody?.collisionBitMask = PhysicsCategory.none
        node.fillColor = UIColor.orange
        node.strokeColor = UIColor.clear
    }
    
    func shoot() {
        guard let node = self.node, node.scene != nil else { return }
        let action = SKAction.move(to: CGPoint(x: node.position.x + velocity.dx, y: node.position.y + velocity.dy), duration: deltaTime)
        node.run(action) {
            self.transform.position = self.node!.position
            self.shoot()
        }
    }
    
    override func transformWillChange(newTransform: NetworkTransform) {
        if (!(self.node!.scene!.intersects(self.node!))) {
            print("Here")
            NetworkManager.destroy(object: self)
            self.node!.removeAllActions()
        }
    }
}
