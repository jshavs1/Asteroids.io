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

class GameViewController: UIViewController, GameSceneDelegate {

    @IBOutlet weak var movementJoystick: Joystick!
    @IBOutlet weak var fireJoystick: Joystick!
    @IBOutlet weak var pingLabel: UILabel!
    var myScene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        GameManager.onUpdate += self.onUpdate
        SocketIOManager.default.onLatency += self.onLatency


        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'

            if let scene = GameScene(fileNamed: "GameScene") {
                myScene = scene
                scene.size = CGSize(width: sceneWidth, height: sceneHeight)
                scene.gameSceneDelegate = self
                scene.scaleMode = .aspectFill
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
            player.move(x: movementJoystick.x, y: movementJoystick.y)
            player.shoot(x: fireJoystick.x, y: fireJoystick.y)
            player.update()
        }
    }

    func onLatency(latency: Double) {
        self.pingLabel.text = "Ping: \(latency.rounded())"
        SocketIOManager.default.ping()
    }
    
    func gameOver(loser: String) {
        //let title = Player.local!.owner == loser ? "You lost" : "You won!"
        //let messege = Player.local!.owner == loser ? "Better luck next time!" : "Congratulations!"
        //let ac = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        //ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        //present(ac, animated: true, completion: nil)
        let size = CGSize(width: sceneWidth, height: sceneHeight)
        let skView = view as! SKView
        if (Player.local!.owner == loser){
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: size, won: false)
            skView.presentScene(gameOverScene, transition: reveal)
            
        } else {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: size, won: true)
            skView.presentScene(gameOverScene, transition: reveal)
            
        }
    }
}
