//
//  Command.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SocketIO

class Command: SocketData {
    let id: String
    let frame: Int
    var actions: JSON
    
    init(id: String) {
        self.id = id
        self.frame = GameManager.default.frame
        self.actions = JSON()
    }
    
    func socketRepresentation() -> SocketData {
        return ["id": id, "frame": frame, "actions": actions]
    }
    
    func addAction(action: String, value: Any) {
        self.actions[action] = value
    }
}
