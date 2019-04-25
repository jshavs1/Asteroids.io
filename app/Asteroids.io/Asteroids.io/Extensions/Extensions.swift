//
//  Extensions.swift
//  Asteroids.io
//
//  Created by Tony on 4/24/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    func roundTo(places: Int) -> CGFloat {
        let divisor = CGFloat(pow(10.0, Double(places)))
        return (self * divisor).rounded() / divisor
    }
}
