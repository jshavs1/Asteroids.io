//
//  NetworkTransform.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import UIKit

struct NetworkTransform: Equatable {
    var x: CGFloat
    var y: CGFloat
    var position: CGPoint {
        set {
            x = newValue.x
            y = newValue.y
        }
        get {
            return CGPoint(x: x, y: y)
        }
    }
    
    init() {
        self.x = 0
        self.y = 0
    }
    
    init(json: JSON) {
        var position = json["position"] as! [String : Any]
        self.x = position["x"] as! CGFloat
        self.y = position["y"] as! CGFloat
    }
    
    static func == (lhs: NetworkTransform, rhs: NetworkTransform) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func dist(to: NetworkTransform) -> CGFloat {
        return sqrt((self.x - to.x)*(self.x - to.x) + (self.y - to.y)*(self.y - to.y))
    }
}
