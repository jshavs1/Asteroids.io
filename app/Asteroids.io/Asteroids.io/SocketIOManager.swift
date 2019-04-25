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
    
    var pingTime: Double!
    var pongTime: Double!
    
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
        }
        _socket.on(clientEvent: .disconnect) { (data, ack) in
            print("Socket disconnected")
        }
        _socket.on("pong") { (data, ack) in
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
        
        print("Socket ready")
        _socket.connect()
    }
    
    func ping() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self._socket.emit("ping")
            self.pingTime = Date().timeIntervalSince1970
        }
    }
    
    func pong() {
        self.pongTime = Date().timeIntervalSince1970
        onLatency.invoke(t: (pongTime - pingTime))
    }
}
