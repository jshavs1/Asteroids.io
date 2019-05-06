//
//  Hit.swift
//  Asteroids.io
//
//  Created by Tony on 5/6/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SocketIO

class Hit: SocketData {
    let A: String
    let B: String
    let typeA: NetworkObjectType
    let typeB: NetworkObjectType
    
    init(A: String, B: String, typeA: NetworkObjectType, typeB: NetworkObjectType) {
        self.A = A
        self.B = B
        self.typeA = typeA
        self.typeB = typeB
    }
    
    init(json: JSON) {
        self.A = json["A"] as! String
        self.B = json["B"] as! String
        self.typeA = NetworkObjectType(rawValue: json["typeA"] as! String)!
        self.typeB = NetworkObjectType(rawValue: json["typeB"] as! String)!
    }
    
    func socketRepresentation() -> SocketData {
        return ["A": A, "B": B, "typeA": typeA.rawValue, "typeB": typeB.rawValue]
    }
}
