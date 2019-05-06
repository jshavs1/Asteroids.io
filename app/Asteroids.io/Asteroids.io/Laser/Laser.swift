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
    var xPos = 0.0
    var yPos = 0.0
    var touchedPoint: CGPoint = CGPoint(x:0.0, y:0.0)
    var playerPoint: CGPoint =  CGPoint(x:0.0, y:0.0)
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        self.node = SKShapeNode()
        self.direction = CGVector.zero
        self.velocity = CGVector.zero
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
    }
    
    init(owner: String, id: String, transform: NetworkTransform, direction: CGVector,  point: CGPoint, toPoint: CGPoint){
        self.node = SKShapeNode()
        self.direction = direction
        self.touchedPoint = toPoint
        self.playerPoint = point
        //self.velocity = CGVector(dx: cos(direction.dx) * Laser.speed * CGFloat(deltaTime), dy: sin(direction.dy) * Laser.speed * CGFloat(deltaTime))
        //self.velocity = CGVector(dx: (direction.dx) * Laser.speed * CGFloat(deltaTime), dy: (direction.dy) * Laser.speed * CGFloat(deltaTime))
        xPos = Double( point.x)
        yPos = Double(point.y)
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
        
    }
    
    init(owner: String, id: String, transform: NetworkTransform, direction: CGVector) {
        self.node = SKShapeNode()
        self.direction = direction
        self.velocity = CGVector(dx: cos(direction.dx) * Laser.speed * CGFloat(deltaTime), dy: sin(direction.dy) * Laser.speed * CGFloat(deltaTime))
        super.init(owner: owner, id: id, transform: transform)
        setupNode()
    }
    
    func setupNode() {
        let rect = CGRect(x: xPos, y: yPos, width: 20, height: 100)
        node.position = playerPoint
        node.path = CGPath(rect: rect, transform: nil)
        node.physicsBody = SKPhysicsBody(rectangleOf: rect.size)
        node.physicsBody!.categoryBitMask = isMine ? playerCategoryMask : enemyCategoryMask
        node.physicsBody!.contactTestBitMask = isMine ? enemyCategoryMask : playerCategoryMask
        node.fillColor = UIColor.orange
        node.strokeColor = UIColor.clear
    }
    
    func shoot() {
        //guard node.scene != nil else { return }
        
        guard node.scene != nil else { return }
        let action = SKAction.move(by: self.velocity, duration: deltaTime)
        node.run(action) {
            self.shoot()
        }
        /*let offset = playerPoint - touchedPoint
        let direction = offset.normalized()
        //let dir = CGVector(dx: playerPoint.x - touchedPoint.x, dy: touchedPoint.y - playerPoint.y)
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 2500
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + playerPoint
        
        let actionMove = SKAction.move(to: realDest, duration: 1.0)
        let actionMoveDone = SKAction.removeFromParent()
        //let action = SKAction.move(to: self.velocity, duration: deltaTime)
        
         node.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        //node.run(actionMove) {
        //    self.shoot()
        //}8*/
    }
    
    //override func transformWillChange(newTransform: NetworkTransform) {
   //     let action = SKAction.move(to: newTransform.position, duration: deltaTime)
    //    node.run(action)
    //}
}
