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
    
    static func instantiate(type: NetworkObjectType) {
        print("Requesting instantiation of \(type.rawValue)")
        NetworkManager.default.instantiate(type: type)
    }
    func instantiate(type: NetworkObjectType) {
        switch type {
        case .player:
            SocketIOManager.socket.emit("instantiate", Instantiate(type: .player))
        case .laser:
            SocketIOManager.socket.emit("instantiate", Instantiate(type: .laser))
        default:
            break
        }
    }
    
    static func update(command: Command) {
        SocketIOManager.socket.emit("update", command)
    }
}
