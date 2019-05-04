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
    var ship: Spaceship!
    let speed: CGFloat = 1000
    
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        super.init(owner: owner, id: id, transform: transform)
        
        if isMine {
            ship = Spaceship(imageNamed: "player")
            NSLog("Our Ship: Player")
        } else {
            ship = Spaceship(imageNamed: "enemy")
            NSLog("Our Ship: Enemy")
        }
        //ship = Spaceship()
        ship.position = CGPoint(x: transform.x, y: transform.y)
        //ship.fillColor = isMine ? UIColor.cyan : UIColor.red
    }
    
    override func transformWillChange(newTransform: NetworkTransform) {
        let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
        ship.run(translate)
    }
}
