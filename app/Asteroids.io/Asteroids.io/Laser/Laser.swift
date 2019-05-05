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
    var direction: CGPoint = CGPoint(x: 0.0, y:0.0)
    
    //let DegreesToRadians =  CFloat(Double.pi/180)
    
    override init(owner: String, id: String, transform: NetworkTransform) {
        super.init(owner: owner, id: id, transform: transform)
        
        projectile = Bullet()
      
        projectile.position = CGPoint(x: transform.x, y: transform.y)
       
    }
    
    override func transformWillChange(newTransform: NetworkTransform) {
        
        let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
        projectile.run(translate)
    }
    
    func moveProjectile(){
        
    }
}
