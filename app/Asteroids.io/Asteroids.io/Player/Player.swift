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
    let speed: CGFloat = 500
    let cooldown: CGFloat = 0.3
    
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
        
        // Selects which sprite to use for the spaceships
        if isMine {
            ship = Spaceship(imageNamed: "player")
            ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.height / 2)
            ship.physicsBody?.categoryBitMask = PhysicsCategory.player
            ship.physicsBody?.contactTestBitMask = PhysicsCategory.enemyProjectile | PhysicsCategory.asteroid
            
        } else {
            ship = Spaceship(imageNamed: "enemy")
            ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.height / 2)
            ship.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            ship.physicsBody?.contactTestBitMask = PhysicsCategory.playerProjectile
        }
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
        
        let angle = atan2(myY, myX)
        myAngle = angle
        ship.zRotation = angle + CGFloat(90 * DegreesToRadians)
        
        let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
        ship.run(translate)
    }
    
    func move(x: CGFloat, y: CGFloat) {
        guard !isStunned else { return }
        
        if CGPoint(x: x, y: y).length() > 0.1 {
            ship.smoke.particleBirthRate = 40
        }
        else {
            ship.smoke.particleBirthRate = 0
        }
        
        let x = x * speed * CGFloat(deltaTime)
        let y = y * speed * CGFloat(deltaTime)
        let pos = CGPoint(x: transform.x + x, y: transform.y + y)
        
        
        
        transform.position = pos
        
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
        print("here")
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
