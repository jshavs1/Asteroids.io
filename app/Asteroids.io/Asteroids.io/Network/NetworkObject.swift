//
//  NetworkObject.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation

class NetworkObject {
    let owner: String
    let id: String
    var transform: NetworkTransform {
        willSet {
            if (transform != newValue) {
                self.transformWillChange(newTransform: newValue)
            }
        }
    }
    var commandBuffer: CommandBuffer!
    
    init(json: JSON) {
        self.owner = json["owner"] as! String
        self.id = json["id"] as! String
        self.transform = NetworkTransform(json: json["transform"] as! JSON)
    }
    
    init(owner: String, id: String, transform: NetworkTransform) {
        self.owner = owner
        self.id = id
        self.transform = transform
        self.commandBuffer = CommandBuffer(length: 125)
    }
    
    func transformWillChange(newTransform: NetworkTransform) {
        return
    }
    
    var newCommand: Command {
        let command = Command(id: id)
        commandBuffer.add(command: command)
        return command
    }
    
    var isMine: Bool {
        get {
            return self.owner == SocketIOManager.socket.sid
        }
    }
}
