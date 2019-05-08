//
//  Player.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Player: NetworkObject {
    static var local: Player?
    static let health: Int = 10
    
    let speed: CGFloat = 500
    let cooldown: CGFloat = 0.3
    
    var currentHealth: Int! {
        didSet {
            let gameScene = self.node!.scene as! GameScene
            if (isMine) {
                gameScene.playerHealthBar.health = CGFloat(currentHealth) / CGFloat(Player.health)
            }
            else {
                gameScene.enemyHealthBar.health = CGFloat(currentHealth) / CGFloat(Player.health)
            }
        }
    }
    var currentCooldown: CGFloat = 0
    var directionX : CGFloat = 0.0
    var directionY: CGFloat = 0.0
    var myAngle: CGFloat = 0.0
    
    var isStunned: Bool = false
    var isInvulnrable: Bool = false
    var canShoot: Bool {
        get { return currentCooldown <= 0 }
    }
    
    var ship: Spaceship {
        get { return node as! Spaceship }
        set { self.node = newValue }
    }
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        super.init(owner: owner, id: id, transform: transform)
        
        self.currentHealth = Player.health
        // Selects which sprite to use for the spaceships
        if isMine {
            ship = Spaceship(imageNamed: "player")
            ship.physicsBody = SKPhysicsBody(rectangleOf: ship.size)
            ship.physicsBody?.categoryBitMask = PhysicsCategory.player
            ship.physicsBody?.contactTestBitMask = PhysicsCategory.enemyProjectile | PhysicsCategory.asteroid
            
        } else {
            ship = Spaceship(imageNamed: "enemy")
            ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.height / 2)
            ship.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            ship.physicsBody?.contactTestBitMask = PhysicsCategory.playerProjectile
        }
        ship.setScale(0.5)
        ship.physicsBody?.collisionBitMask = 0
        ship.physicsBody?.affectedByGravity = false
        ship.position = CGPoint(x: transform.x, y: transform.y)
    }
    
    // Rotates the spaceship with its motion
    override func transformWillChange(newTransform: NetworkTransform) {
        
        let myX = transform.x - newTransform.position.x
        let myY = transform.y - newTransform.position.y
        directionY = myY
        directionX = myX
        
        let angle = atan2(myY, myX) + 90 * CGFloat(DegreesToRadians)
        
        let rotate = SKAction.rotate(toAngle: angle, duration: deltaTime, shortestUnitArc: true)
        
        if (transform.dist(to: newTransform) < 100.0) {
            let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
            ship.run(translate)
        }
        else {
            ship.removeAllActions()
            ship.position = newTransform.position
        }
        
        ship.run(rotate)
    }
    
    func move(x: CGFloat, y: CGFloat) {
        guard !isStunned else { return }
        
        let x = x * speed * CGFloat(deltaTime)
        let y = y * speed * CGFloat(deltaTime)
        
        let command = newCommand
        command.addAction(action: "x", value: x)
        command.addAction(action: "y", value: y)
        NetworkManager.update(command: command)
    }
    
    func shoot(x: CGFloat, y: CGFloat) {
        guard !isStunned, canShoot, sqrt(x * x + y * y) > 0.5 else { return }
        
        let position = CGPoint(x: transform.x + x * ship.size.width, y: transform.y + y * ship.size.height)
                
        var json = JSON()
        json["x"] = position.x
        json["y"] = position.y
        json["dx"] = x
        json["dy"] = y
        
        NetworkManager.instantiate(type: .laser, data: json)
        
        currentCooldown = cooldown
    }
    
    func stun() {
        let stun = SKAction(named: "Stun")!
        isStunned = true
        ship.run(stun) {
            self.isStunned = false
        }
    }
    
    func hit() {
        let hit = SKAction(named: "Hit")!
        isInvulnrable = true
        ship.run(hit) {
            self.isInvulnrable = false
        }
    }
    
    func update() {
        currentCooldown -= CGFloat(deltaUpdateTime)
    }
}
