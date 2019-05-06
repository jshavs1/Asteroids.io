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

class GameViewController: UIViewController {
    
    @IBOutlet weak var movementJoystick: Joystick!
    @IBOutlet weak var fireJoystick: Joystick!
    @IBOutlet weak var pingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameManager.onUpdate += self.onUpdate
        SocketIOManager.default.onLatency += self.onLatency
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
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
            let x = movementJoystick.x * player.speed * CGFloat(deltaTime)
            let y = movementJoystick.y * player.speed * CGFloat(deltaTime)
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
}
