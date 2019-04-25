//
//  CommandBuffer.swift
//  Asteroids.io
//
//  Created by Tony on 4/24/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation

class CommandBuffer {
    var buffer: [Command]
    var length: Int
    
    
    init(length: Int) {
        self.length = length
        self.buffer = []
    }
    
    func add(command: Command) {
        if (buffer.count < length) {
            buffer.append(command)
        }
        else {
            buffer.removeFirst()
            buffer.append(command)
        }
    }
    
    func revertTo(frame: Int, f: (Command) -> Void) {
        let currentFrame = GameManager.default.frame
        let index = currentFrame - frame
        
        for i in stride(from: buffer.count - 1, to: index, by: -1) {
            f(buffer[i])
        }
    }
    
    func simulateFrom(frame: Int, f: (Command) -> Void) {
        let currentFrame = GameManager.default.frame
        let index = currentFrame - frame
        
        for i in index..<buffer.count {
            f(buffer[i])
        }
    }
}
