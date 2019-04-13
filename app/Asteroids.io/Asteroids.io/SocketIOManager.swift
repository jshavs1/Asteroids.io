//
//  SocketIOManager.swift
//  Asteroids.io
//
//  Created by Tony on 4/13/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager {
    private static var _default: SocketIOManager?
    static var `default`: SocketIOManager {
        get {
            if (_default == nil) {
                _default = SocketIOManager()
            }
            return _default!
        }
    }
    
    var manager: SocketManager
    var socket: SocketIOClient
    
    
    init() {
        self.manager = SocketManager(socketURL: URL(string: host!)!, config: [.compress])
        self.socket = self.manager.defaultSocket
    }
    
    func configureSocket() {
        print("Configuring Socket")
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket connected to host")
        }
        socket.on("messege") { (data, ack) in
            var messege = data[0] as! [String : String]
            print(messege["messege"] ?? "error reading messege")
        }
        
        print("Socket ready")
        socket.connect()
    }
}
