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
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    
    var myScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        SocketIOManager.default.onLatency += self.onLatency
        SocketIOManager.default.onConnect += self.onConnect
        SocketIOManager.default.onDisconnect += self.onDisconnect
        SocketIOManager.default.onStart += self.onStart
        
        activityIndicator.startAnimating()
        
        GameManager.onUpdate += onUpdate


        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'

            if let scene = GameScene(fileNamed: "GameScene") {
                myScene = scene
                scene.size = CGSize(width: sceneWidth, height: sceneHeight)
                scene.gameSceneDelegate = self
                scene.scaleMode = .aspectFit
                view.presentScene(scene)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (SocketIOManager.default._socket.status == .notConnected || SocketIOManager.default._socket.status == .disconnected) {
            presentMenu()
        }
        
        DispatchQueue.main.async {
            self.activityView.isHidden = false
            self.activityLabel.text = "Connecting to server"
            if let myScene = self.myScene {
                myScene.resetHealthBars()
            }
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
    
    func onConnect(_: Void) {
        activityLabel.text = "Searching for game"
    }
    
    func onStart(_: Void) {
        DispatchQueue.main.async {
            self.activityView.isHidden = true
        }
    }
    
    func onDisconnect(_: Void) {
        DispatchQueue.main.async {
            self.activityView.isHidden = false
            self.gameOverView.isHidden = true
        }
        
        GameManager.stop()
        presentMenu()
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        SocketIOManager.default.disconnect()
    }
    
    func gameOver(loser: String) {
        DispatchQueue.main.async {
            self.gameOverView.isHidden = false
            if (loser == SocketIOManager.default._socket.sid) {
                self.gameOverLabel.text = "Oof. Better luck next time"
            }
            else {
                self.gameOverLabel.text = "Winner winner chicken dinner!"
            }
        }
    }
    
    func presentMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}
