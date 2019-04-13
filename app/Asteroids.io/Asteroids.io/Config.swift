//
//  Config.swift
//  Asteroids.io
//
//  Created by Tony on 4/13/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation

var host: String? {
    get {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String : AnyObject] else { return nil }
        
        return dict["HOST_URL"] as? String
    }
}
