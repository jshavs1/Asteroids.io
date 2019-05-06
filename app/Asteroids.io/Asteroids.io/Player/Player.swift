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
    var directionX : CGFloat = 0.0
    var directionY: CGFloat = 0.0
    var myAngle: CGFloat = 0.0
    let DegreesToRadians =  CFloat(Double.pi/180)
    var lives = 3
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        super.init(owner: owner, id: id, transform: transform)
        
        // Selects which sprite to use for the spaceships
        if isMine {
            ship = Spaceship(imageNamed: "player")
        } else {
            ship = Spaceship(imageNamed: "enemy")
        }
        ship.position = CGPoint(x: transform.x, y: transform.y)
    }
    
    // Rotates the spaceship with its motion
    override func transformWillChange(newTransform: NetworkTransform) {
        
        let myX = transform.x - newTransform.position.x
        let myY = transform.y - newTransform.position.y
        directionY = myY
        directionX = myX
        
        let angle = atan2(myY, myX)
        myAngle = angle
        ship.zRotation = angle + CGFloat(90 * DegreesToRadians)
        
        let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
        ship.run(translate)
    }
    
    func shoot(dir: CGVector) {
        let magnitude = sqrt(dir.dx * dir.dx + dir.dy * dir.dy)
        let x = dir.dx / magnitude
        let y = dir.dy / magnitude
        
        let position = CGPoint(x: transform.x + x * ship.size.width, y: transform.y + y * ship.size.height)
        
        print(position)
        
        var json = JSON()
        json["x"] = position.x
        json["y"] = position.y
        json["dx"] = dir.dx
        json["dy"] = dir.dy
        
        NetworkManager.instantiate(type: .laser, data: json)
    }
}
