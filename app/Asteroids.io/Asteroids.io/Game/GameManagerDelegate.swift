//
//  GameManagerDelegate.swift
//  Asteroids.io
//
//  Created by Tony on 4/23/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation

protocol GameManagerDelegate {
    func instantiate(object: NetworkObject, type: NetworkObjectType)
}
