//
//  NetworkManager.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation

class NetworkManager {
    static var _default: NetworkManager?
    static var `default`: NetworkManager {
        get {
            if (_default == nil) {
                _default = NetworkManager()
            }
            return _default!
        }
    }

    init() {}

    static func instantiate(type: NetworkObjectType, data: JSON? = nil) {
        print("Requesting instantiation of \(type.rawValue)")
        NetworkManager.default.instantiate(type: type, data: data)
    }
    func instantiate(type: NetworkObjectType, data: JSON? = nil) {
        SocketIOManager.socket.emit("instantiate", Instantiate(type: type, data: data))
    }

    static func destroy(object: NetworkObject) {
        SocketIOManager.socket.emit("destroy", object.id)
    }

    static func update(command: Command) {
        SocketIOManager.socket.emit("update", command)
    }
    
    static func hit(hit: Hit) {
        SocketIOManager.socket.emit("hit", hit)
    }
}
