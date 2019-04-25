//
//  Instantiate.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SocketIO

class Instantiate: SocketData {
    let owner: String
    let type: NetworkObjectType
    
    init(type: NetworkObjectType) {
        self.owner = SocketIOManager.socket.sid
        self.type = type
    }
    
    func socketRepresentation() -> SocketData {
        return ["owner": owner, "type": type.rawValue]
    }
}

class InstantiateResponse {
    let owner: String
    let id: String
    let type: NetworkObjectType
    var transform: NetworkTransform
    
    
    init(json: JSON) {
        self.owner = json["owner"] as! String
        self.id = json["id"] as! String
        self.type = NetworkObjectType(rawValue: json["type"] as! String)!
        self.transform = NetworkTransform(json: json["transform"] as! JSON)
    }
}
