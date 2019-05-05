//
//  Laser.swift
//  Asteroids.io
//
//  Created by user915547 on 5/4/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Laser: NetworkObject {
    static var local: Laser?
    var projectile: Bullet!
    let speed: CGFloat = 1000
    var directionX = 0
    var directionY = 0
    

    let DegreesToRadians =  CFloat(Double.pi/180)
    
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        super.init(owner: owner, id: id, transform: transform)
        
        projectile = Bullet()
        //ship = Spaceship()
        projectile.position = CGPoint(x: transform.x, y: transform.y)
        //ship.fillColor = isMine ? UIColor.cyan : UIColor.red
    }
    
    override func transformWillChange(newTransform: NetworkTransform) {
        
        let myX = projectile.position.x - newTransform.position.x
        let myY = projectile.position.x - newTransform.position.y
        
        //let angle = atan2(myY, myX)
        
        //ship.zRotation = angle + CGFloat(90 * DegreesToRadians)
        
        let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
        projectile.run(translate)
    }
}
