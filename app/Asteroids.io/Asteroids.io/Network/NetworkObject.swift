//
//  NetworkObject.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

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
    var node: SKNode? {
        didSet {
            node?.userData = NSMutableDictionary()
            node?.userData!["networkObject"] = self
        }
    }
    
    init(json: JSON) {
        self.owner = json["owner"] as! String
        self.id = json["id"] as! String
        self.transform = NetworkTransform(json: json["transform"] as! JSON)
    }
    
    init(owner: String, id: String, transform: NetworkTransform) {
        self.owner = owner
        self.id = id
        self.transform = transform
    }
    
    func transformWillChange(newTransform: NetworkTransform) {
        return
    }
    
    func destroy() {
        NetworkManager.destroy(object: self)
    }
    
    var newCommand: Command {
        let command = Command(id: id)
        return command
    }
    
    var isMine: Bool {
        get {
            return self.owner == SocketIOManager.socket.sid
        }
    }
}
