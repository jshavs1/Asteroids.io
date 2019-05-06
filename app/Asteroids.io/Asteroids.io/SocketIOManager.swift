//
//  SocketIOManager.swift
//  Asteroids.io
//
//  Created by Tony on 4/13/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SocketIO
import CoreLocation

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
    
    var _manager: SocketManager
    static var manager: SocketManager {
        return SocketIOManager.default._manager
    }
    var _socket: SocketIOClient
    static var socket: SocketIOClient {
        return SocketIOManager.default._socket
    }
    
    var pingTime: Double = 0
    var pongTime: Double = 0
    
    var onLatency: Event<Double>
    
    
    init() {
        self._manager = SocketManager(socketURL: URL(string: host!)!, config: [.compress])
        self._socket = self._manager.defaultSocket
        self.onLatency = Event<Double>()
    }
    
    func configureSocket() {
        print("Configuring Socket")
        
        // This callback will be executed when the client's socket initially connects to
        // the server.
        _socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket connected to host")
            self.ping()
        }
        _socket.on(clientEvent: .disconnect) { (data, ack) in
            print("Socket disconnected")
        }
        _socket.on("mypong") { (data, ack) in
            self.pong()
        }
        _socket.on("start") { (data, ack) in
            var json = data[0] as! JSON
            print("Starting game")
            
            deltaTime = (json["deltaTime"] as! Double) / 1000
            
            NetworkManager.instantiate(type: .player)
            GameManager.synchronizedStart(at: json["time"] as! UInt64)
        }
        _socket.on("instantiate") { (data, ack) in
            let json = data[0] as! JSON
            
            print("Instantiation received")
            GameManager.instantiate(response: InstantiateResponse(json: json))
        }
        _socket.on("update") { (data, ack) in
            let json = data[0] as! JSON
            let object = NetworkObject(json: json)
            
            GameManager.update(object: object)
        }
        _socket.on("destroy") { (data, ack) in
            let json = data[0] as! JSON
            let id = json["id"] as! String
            GameManager.destroy(id: id)
        }
        
        print("Socket ready")
        _socket.connect()
    }
    
    func ping() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.pingTime = Date().timeIntervalSince1970 * 1000
            self._socket.emit("myping")
        })
    }
    
    func pong() {
        self.pongTime = Date().timeIntervalSince1970 * 1000
        onLatency.invoke(t: (pongTime - pingTime))
    }
}
