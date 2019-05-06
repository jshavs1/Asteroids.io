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
        ship = Spaceship()
        ship.position = CGPoint(x: transform.x, y: transform.y)
        ship.fillColor = isMine ? UIColor.cyan : UIColor.red
    }
    
    override func transformWillChange(newTransform: NetworkTransform) {
        let translate = SKAction.move(to: newTransform.position, duration: deltaTime)
        ship.run(translate)
    }
    
    func shoot(dir: CGVector) {
        let magnitude = sqrt(dir.dx * dir.dx + dir.dy * dir.dy)
        let x = dir.dx / magnitude
        let y = dir.dy / magnitude
        
        let position = CGPoint(x: transform.x + cos(x) * ship.frame.size.width, y: transform.y + sin(y) * ship.frame.size.width)
        
        var json = JSON()
        json["x"] = position.x
        json["y"] = position.y
        json["dx"] = dir.dx
        json["dy"] = dir.dy
        
        NetworkManager.instantiate(type: .laser, data: json)
    }
}
