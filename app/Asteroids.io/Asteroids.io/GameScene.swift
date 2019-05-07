//
//  GameScene.swift
//  Asteroids.io
//
//  Created by Tony on 4/11/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GameManagerDelegate, SKPhysicsContactDelegate {
    
    var isPlayerThere = false
    var didTap = false
    var touchLocation: CGPoint = CGPoint(x: 0.0,y: 0.0)
    var gameSceneDelegate: GameSceneDelegate?
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        GameManager.delegate = self
        
        let background = SKSpriteNode(imageNamed: "sky2")
        background.zPosition = -500
        background.size.width = self.size.width
        background.size.height = self.size.height / 2 + 300
        addChild(background)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func instantiate(object: NetworkObject, type: NetworkObjectType) {
        print("instantiating \(type.rawValue) in scene")
        switch type {
        case .player:
            let player = object as! Player
            player.ship.name = player.id
            if (player.isMine) {
                Player.local = player
            }

            player.ship.zPosition = 300
            player.ship.physicsBody?.usesPreciseCollisionDetection = true

            addChild(player.ship)
            break
        case .laser:
            let laser = object as! Laser
            addChild(laser.node!)
            laser.shoot()
            break
        case .asteroid:
            let asteroid = object as! Asteroid
            addChild(asteroid.asteroid)
            asteroid.launch()
            break
        }
    }
    
    func destroy(object: NetworkObject) {
        print("Destroying network object")
        object.node?.removeAllActions()
        object.node?.removeAllChildren()
        object.node?.removeFromParent()
        object.node = nil
    }
    
    func gameOver(loser: String) {
        gameSceneDelegate?.gameOver(loser: loser)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchDown(atPoint: (touches.first?.location(in: self))!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchMoved(toPoint: (touches.first?.location(in: self))!)
    }
    
    // This notices when the current player fires their bullet
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, Player.local != nil else {
            return
        }
        
        touchLocation = touch.location(in: self)
        didTap = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        guard let nObjA = nodeA.userData!["networkObject"] as? NetworkObject else { return }
        guard let nObjB = nodeB.userData!["networkObject"] as? NetworkObject else { return }
                
        switch nodeA.physicsBody!.categoryBitMask {
        case PhysicsCategory.playerProjectile:
            if (nodeB.physicsBody!.categoryBitMask == PhysicsCategory.enemy) {
                NetworkManager.hit(hit: Hit(A: nObjA.id, B: nObjB.id, typeA: .laser, typeB: .player))
            }
            break
        case PhysicsCategory.player:
            if (nodeB.physicsBody!.categoryBitMask == PhysicsCategory.asteroid) {
                NetworkManager.hit(hit: Hit(A: nObjB.id, B: nObjA.id, typeA: .asteroid, typeB: .player))
            }
        default:
            break
        }
        
    }
}
