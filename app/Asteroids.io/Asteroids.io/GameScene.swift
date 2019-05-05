//
//  GameScene.swift
//  Asteroids.io
//
//  Created by Tony on 4/11/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GameManagerDelegate {
    
    //var viewController: GameViewController!
    
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let asteroid  : UInt32 = 0b1       // 1
        static let projectile: UInt32 = 0b10      // 2
        static let player    : UInt32 = 0b1
    }
    
    
    
    override func didMove(to view: SKView) {
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
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        //run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        NSLog("FIREEE")
        
        if Player.local == nil {
            return
        }
        
        if let player = Player.local!.ship{
            let touchLocation = touch.location(in: self)
            NSLog("FIREEE")
            // 2 - Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "bolt")
            projectile.position.x = player.position.x
            projectile.position.y = player.position.y
            
            // 3 - Determine offset of location to projectile
            let offset = touchLocation - projectile.position
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            // 5 - OK to add now - you've double checked position
            addChild(projectile)
            
            // 6 - Get the direction of where to shoot
            let direction = offset//offset.normalized()
            
            // 7 - Make it shoot far enough to be guaranteed off screen
            let shootAmount = direction * 1000.0
            
            // 8 - Add the shoot amount to the current position
            let realDest = shootAmount + projectile.position
            
            // 9 - Create the actions
            let actionMove = SKAction.move(to: realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            
            //let myX = player.position.x - touchLocation.x
            //let myY = player.position.y - touchLocation.y
            
            //let angle = atan2(myY, myX)
            
            //player.zRotation = angle + CGFloat(90 * DegreesToRadians)
            
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
            //player.run(actionRotate)
            
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    func fire(){
        NSLog("Fired in GameScene")
    }
    
}

let DegreesToRadians =  CFloat(Double.pi/180)

// These operators allow us to calculate the trajectory of the projectiles
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}
