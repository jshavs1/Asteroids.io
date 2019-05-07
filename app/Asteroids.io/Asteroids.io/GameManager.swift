//
//  GameManager.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

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
    var isOver: Bool
    var lastUpdateTime: Double
    
    init() {
        self.frame = 0
        self.objects = [String : NetworkObject]()
        self._onUpdate = Event()
        self.isOver = false
        self.lastUpdateTime = 0
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
        lastUpdateTime = Date().timeIntervalSince1970
        loop = Timer.scheduledTimer(withTimeInterval: deltaTime, repeats: true, block: { (_) in
            self.update()
            self.frame += 1;
        })
    }
    
    static func stop() {
        GameManager.default.stop()
    }
    func stop() {
        loop.invalidate()
        self.frame = 0
    }
    
    func update() {
        if (isOver) {return}
        let newUpdateTime = Date().timeIntervalSince1970
        deltaUpdateTime = newUpdateTime - lastUpdateTime
        lastUpdateTime = newUpdateTime
        self._onUpdate.invoke(t: self.frame)
    }
    static func update(object: NetworkObject){
        if let localObj = GameManager.default.objects[object.id] {
            localObj.transform = object.transform
        }
    }
    
    static func instantiate(response: InstantiateResponse) {
        GameManager.default.instantiate(response: response)
    }
    func instantiate(response: InstantiateResponse) {
        if (isOver) {return}
        var object: NetworkObject!
        switch response.type {
        case .player:
            object = Player(owner: response.owner, id: response.id, transform: response.transform)
            break
        case .laser:
            let dir = CGVector(dx: response.data!["dx"] as! Double, dy: response.data!["dy"] as! Double)
            object = Laser(owner: response.owner, id: response.id, transform: response.transform, direction: dir)
            break
        case .asteroid:
            let position: CGPoint!
            let direction: CGVector!
            let size = Size(rawValue: response.data!["size"] as! String)!
            if (size != .small) {
                position = calculateAsteroidPosition(side: response.data!["side"] as! Int, offset: response.data!["offset"] as! Double)
                direction = calculateAsteroidDirection(position: position, angle: response.data!["angle"] as! Double)
            }
            else {
                position = CGPoint(x: response.data!["x"] as! CGFloat, y: response.data!["y"] as! CGFloat)
                direction = CGVector(dx: response.data!["dx"] as! CGFloat, dy: response.data!["dy"] as! CGFloat)
            }
            object = Asteroid(owner: response.owner, id: response.id, transform: response.transform, size: size, position: position, direction: direction)
            
            break
        }
        
        objects[object.id] = object
        _delegate?.instantiate(object: object, type: response.type)
    }
    
    static func destroy(id: String) {
        GameManager.default.destroy(id: id)
    }
    func destroy(id: String) {
        if let networkObject = self.objects.removeValue(forKey: id) {
            GameManager.delegate?.destroy(object: networkObject)
        }
    }
    
    static func gameOver(loser: String) {
        GameManager.default.gameOver(loser: loser)
    }
    func gameOver(loser: String) {
        if (isOver) { return }
        isOver = true
        GameManager.delegate?.gameOver(loser: loser)
        stop()
    }
    
    static func hit(hit: Hit) {
        GameManager.default.hit(hit: hit)
    }
    func hit(hit: Hit) {
        if (isOver) { return }
        
        guard let nObjB = objects[hit.B] else {return}
        
        switch hit.typeB {
        case .player:
            if (hit.typeA == .asteroid) {
                let player = nObjB as! Player
                player.stun()
            }
            if (hit.typeA == .laser) {
                let player = nObjB as! Player
                player.currentHealth = hit.data!["health"] as! Int
                player.hit()
            }
        default:
            break
        }
    }
    
    static func findObject(id: String) -> NetworkObject? {
        return GameManager.default.objects[id]
    }
    
    func calculateAsteroidDirection(position: CGPoint, angle: Double) -> CGVector {
        let x: Double = Double(-position.x) / Double(position.length())
        let y: Double = Double(-position.y) / Double(position.length())
        let theta = Double(DegreesToRadians) * angle
        
        return CGVector(dx: x * cos(theta) - y * sin(theta), dy: x * sin(theta) + y * cos(theta))
    }
    
    func calculateAsteroidPosition(side: Int, offset: Double) -> CGPoint {
        let x: Double!
        let y: Double!
        switch side {
        case 0:
            x = -sceneWidth / 2; y = sceneHeight / 2 * offset
            break
        case 1:
            x = sceneWidth / 2 * offset; y = sceneHeight / 2
            break
        case 2:
            x = sceneWidth / 2; y = sceneHeight / 2 * offset
            break
        case 3:
            x = sceneWidth / 2 * offset; y = -sceneHeight / 2
            break
        default:
            x = 0.0; y = 0.0
        }
        
        return CGPoint(x: x, y: y)
    }
    
}
// These operators allow us to calculate the trajectory of the projectiles
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
        
    }
}
