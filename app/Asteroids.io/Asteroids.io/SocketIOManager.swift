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
        
        // This callback will be executed when the client's socket initially connects to
        // the server.
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket connected to host")
        }
        
        // Example of how socket receives data from the server
        
        // When the client initially connects to the server, the server automatically sends
        // a "Welcome!" string through the socket on the "messege" channel. This callback
        // is executed once the data arrives on the "messege" channel.
        socket.on("messege") { (data, ack) in
            
            // The data varibale is an array of JSON objects which only contains 1 element.
            // Grab the JSON object at 0 index, convert it to a Dictionary and print the value
            // at the "messege" key.
            
            var messege = data[0] as! [String : String]
            
            // "Welcome!" printed to log
            print(messege["messege"] ?? "error reading messege")
        }
        
        print("Socket ready")
        socket.connect()
    }
}
