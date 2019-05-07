//
//  Config.swift
//  Asteroids.io
//
//  Created by Tony on 4/13/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import UIKit

typealias JSON = [String : Any]

var host: String? {
    get {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String : AnyObject] else { return nil }
        
        return dict["HOST_URL"] as? String
    }
}

let sceneWidth: Double = 1600
let sceneHeight: Double = 900

var deltaTime: TimeInterval = floor(10.0/1000.0)
var deltaUpdateTime: TimeInterval = 0.0

struct PhysicsCategory {
    static let none                 : UInt32 = 0
    static let all                  : UInt32 = UInt32.max
    static let player               : UInt32 = 0b1
    static let enemy                : UInt32 = 0b10
    static let playerProjectile     : UInt32 = 0b100
    static let enemyProjectile      : UInt32 = 0b1000
    static let asteroid             : UInt32 = 0b10000
}

let DegreesToRadians =  CFloat(Double.pi/180)
