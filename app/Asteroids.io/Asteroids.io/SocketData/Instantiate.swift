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
    let data: JSON?
    
    init(type: NetworkObjectType, data: JSON?) {
        self.owner = SocketIOManager.socket.sid
        self.type = type
        self.data = data
    }
    
    func socketRepresentation() -> SocketData {
        return ["owner": owner, "type": type.rawValue, "data": data ?? JSON()]
    }
}

class InstantiateResponse {
    let owner: String
    let id: String
    let type: NetworkObjectType
    var transform: NetworkTransform
    var data: JSON?
    
    
    init(json: JSON) {
        self.owner = json["owner"] as! String
        self.id = json["id"] as! String
        self.type = NetworkObjectType(rawValue: json["type"] as! String)!
        self.transform = NetworkTransform(json: json["transform"] as! JSON)
        self.data = json["data"] as? JSON
    }
}
