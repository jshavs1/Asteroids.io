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
            let x = movementJoystick.x * player.speed * CGFloat(deltaTime)
            let y = movementJoystick.y * player.speed * CGFloat(deltaTime)
            let pos = CGPoint(x: player.transform.x + x, y: player.transform.y + y)

            player.transform.position = pos

            let command = player.newCommand
            command.addAction(action: "x", value: x)
            command.addAction(action: "y", value: y)
            NetworkManager.update(command: command)
        }

        if let laser = Laser.local {
            let x: CGFloat = CGFloat(laser.directionX)
            let y: CGFloat = CGFloat(laser.directionY)
            let pos : CGPoint = CGPoint(x: laser.projectile.position.x + x, y: laser.projectile.position.y + y)

            laser.transform.position = pos

            let command = laser.newCommand
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
