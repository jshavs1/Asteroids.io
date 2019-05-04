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
    
    let DegreesToRadians =  CFloat(Double.pi/180)
    
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
        
        let myX = ship.position.x - newTransform.position.x
        let myY = ship.position.y - newTransform.position.y
        
        let angle = atan2(myY, myX)
        
        ship.zRotation = angle + CGFloat(90 * DegreesToRadians)
        
        let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
        ship.run(translate)
    }
}
