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
        print("instantiating \(type.rawValue) in scene")
        switch type {
        case .player:
            let player = object as! Player
            player.ship.name = player.id
            if (object.owner == SocketIOManager.socket.sid) {
                Player.local = player
            }
            addChild(player.ship)
        case .laser:
            let laser = object as! Laser
            addChild(laser.node)
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchDown(atPoint: (touches.first?.location(in: self))!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchMoved(toPoint: (touches.first?.location(in: self))!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchUp(atPoint: (touches.first?.location(in: self))!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
