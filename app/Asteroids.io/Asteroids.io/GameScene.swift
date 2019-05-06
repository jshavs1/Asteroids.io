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
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let asteroid  : UInt32 = 0b1       // 1
        static let projectile: UInt32 = 0b10      // 2
        static let player    : UInt32 = 0b1
    }
    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        GameManager.delegate = self
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func instantiate(object: NetworkObject, type: NetworkObjectType) {
        
        let background = SKSpriteNode(imageNamed: "sky2")
        background.zPosition = -500
        background.size.width = self.size.width
        background.size.height = self.size.height / 2 + 300
        addChild(background)
        
        print("instantiating \(type.rawValue) in scene")
        switch type {
        case .player:
            let player = object as! Player
            player.ship.name = player.id
            if (object.owner == SocketIOManager.socket.sid) {
                Player.local = player
            }

            player.ship.zPosition = 300
            player.ship.physicsBody?.usesPreciseCollisionDetection = true

            addChild(player.ship)
        case .laser:
            let laser = object as! Laser
            addChild(laser.node)
            laser.shoot()
        }
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
    
}

let DegreesToRadians =  CFloat(Double.pi/180)
