//
//  GameManager.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation

class GameManager {
    static var _default: GameManager?
    static var `default`: GameManager {
        get {
            if (_default == nil) {
                _default = GameManager()
            }
            return _default!
        }
    }
    var _delegate: GameManagerDelegate?
    static var delegate: GameManagerDelegate? {
        set {
            GameManager.default._delegate = newValue
        }
        get {
            return GameManager.default._delegate
        }
    }
    public var _onUpdate: Event<Int>
    static var onUpdate: Event<Int> {
        get {
            return GameManager.default._onUpdate
        }
        set {
            GameManager.default._onUpdate = newValue
        }
    }
    
    var loop: Timer!
    public var frame: Int
    private var objects: [String : NetworkObject]
    
    init() {
        self.frame = 0
        self.objects = [String : NetworkObject]()
        self._onUpdate = Event()
    }
    
    static func synchronizedStart(at: UInt64) {
        GameManager.default.synchronizedStart(at: at)
    }
    private func synchronizedStart(at: UInt64) {
        let currentTime = Date().timeIntervalSince1970
        let currentTimeMilli = UInt64(currentTime * 1000)
        
        let timeUntilStart = at - currentTimeMilli
        
        guard timeUntilStart > 0 else { print("time until start is negative"); return }
        
        print("Starting game in \(timeUntilStart / 1000)")
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timeUntilStart / 1000), repeats: false) { (_) in
            self.start()
        }
    }
    
    private func start() {
        print("Starting update loop")
        loop = Timer.scheduledTimer(withTimeInterval: deltaTime, repeats: true, block: { (_) in
            self.update()
            self.frame += 1;
        })
    }
    
    func update() {
        self._onUpdate.invoke(t: self.frame)
    }
    
    static func stop() {
        GameManager.default.stop()
    }
    func stop() {
        loop.invalidate()
        self.frame = 0
    }
    
    static func instantiate(response: InstantiateResponse) {
        var object: NetworkObject!
        switch response.type {
        case .player:
            object = Player(owner: response.owner, id: response.id, transform: response.transform)
        }
        
        GameManager.default.objects[object.id] = object
        delegate?.instantiate(object: object, type: response.type)
    }
    
    static func findObject(id: String) -> NetworkObject? {
        return GameManager.default.objects[id]
    }
    
    static func update(object: NetworkObject){
        if let localObj = GameManager.default.objects[object.id] {
            localObj.transform = object.transform
        }
    }
    
}
