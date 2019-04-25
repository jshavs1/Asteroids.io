//
//  Event.swift
//  Asteroids.io
//
//  Created by Tony on 4/24/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation

class Event<T> {
    
    typealias EventHandler = (T) -> ()
    
    var eventHandlers: [EventHandler]
    
    init() {
        eventHandlers = []
    }
    
    static func += (lhs: inout Event, rhs: @escaping EventHandler) {
        lhs.eventHandlers.append(rhs)
    }
    
    func invoke(t: T) {
        for event in eventHandlers {
            event(t)
        }
    }
}
