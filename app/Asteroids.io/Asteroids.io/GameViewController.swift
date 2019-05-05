//
//  GameViewController.swift
//  Asteroids.io
//
//  Created by Tony on 4/11/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameManagerDelegate{
    
    @IBOutlet weak var joystick: Joystick!
    @IBOutlet weak var pingLabel: UILabel!
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let asteroid  : UInt32 = 0b1
        static let projectile: UInt32 = 0b10
        static let player    : UInt32 = 0b1
    }
    //var myScene: SKScene
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GameScene.viewController = self
        
        GameManager.onUpdate += self.onUpdate
        SocketIOManager.default.onLatency += self.onLatency
        SocketIOManager.default.ping()
        
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                //scene.viewController = self
                //myScene = (GameScene) scene
                // Present the scene
                view.presentScene(scene)
            }
            
           
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func onUpdate(frame: Int) {
        if let player = Player.local {
            let x = joystick.x * player.speed * CGFloat(deltaTime)
            let y = joystick.y * player.speed * CGFloat(deltaTime)
            let pos = CGPoint(x: player.transform.x + x, y: player.transform.y + y)
            
            player.transform.position = pos
            
            let command = player.newCommand
            command.addAction(action: "x", value: x)
            command.addAction(action: "y", value: y)
            NetworkManager.update(command: command)
        }
    }
    
    func onLatency(latency: Double) {
        self.pingLabel.text = "Ping: \(latency.rounded())"
        SocketIOManager.default.ping()
    }
    
   
    
    func handleTap(gesture: UITapGestureRecognizer) -> Void {
        NSLog("FIRE")
        let gestureX = gesture.location(in:  gesture.view).x
        let gestureY = gesture.location(in: gesture.view).y
        if let player = Player.local {
            let directionX = player.directionX - gestureX
            let directionY = player.directionY - gestureY
            let projectile = Bullet()
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            projectile.position.x = directionX
            projectile.position.y = directionY
            
            
            
            
        }
    }
    @IBAction func PlayerFired(_ sender: Any) {
        /*NSLog("FIRE")
        if let player = Player.local {
            let directionX = player.directionX
            let directionY = player.directionY
            let projectile = Bullet()
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            projectile.position.x = player.directionX
            projectile.position.y = player.directionY
            
        }*/
        
    }
}
