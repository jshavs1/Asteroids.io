//
//  Background.swift
//  Asteroids.io
//
//  Created by Tony on 5/14/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKShapeNode  {
    
    static let colorDuration: TimeInterval = 1.0
    static let colors: [UIColor] = [
        UIColor(red: 0.0, green: 0.0, blue: 25.0/255.0, alpha: 1.0),
        UIColor(red: 13.0/255.0, green: 0.0, blue: 25.0/255.0, alpha: 1.0),
        UIColor(red: 25.0/255.0, green: 0.0, blue: 25.0/255.0, alpha: 1.0),
        UIColor(red: 25.0/255.0, green: 0.0, blue: 12.0/255.0, alpha: 1.0),
        UIColor(red: 25.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0),
        UIColor(red: 25.0/255.0, green: 13.0/255.0, blue: 0.0, alpha: 1.0),
        UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 0.0, alpha: 1.0),
        UIColor(red: 13.0/255.0, green: 25.0/255.0, blue: 0.0, alpha: 1.0),
        UIColor(red: 0.0, green: 25.0/255.0, blue: 0.0, alpha: 1.0),
        UIColor(red: 0.0, green: 25.0/255.0, blue: 13.0/255.0, alpha: 1.0),
        UIColor(red: 0.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0),
        UIColor(red: 0.0, green: 13.0/255.0, blue: 25.0/255.0, alpha: 1.0)
    ]
    var emitter: SKEmitterNode
    
    override init() {
        self.emitter = SKEmitterNode(fileNamed: "Stars.sks")!
        super.init()
        self.path = CGPath(rect: CGRect(x: -sceneWidth/2, y: -sceneHeight/2, width: sceneWidth, height: sceneHeight), transform: nil)
        self.fillColor = UIColor.black
        self.strokeColor = UIColor.clear
        self.emitter.targetNode = self
        self.emitter.position = CGPoint(x: 0, y: 0)
        addChild(self.emitter)
    }
    
    func animate(target: Int) {
        let action = SKAction.customAction(withDuration: Background.colorDuration) { (node, elapsedTime) in
            let targetColor = Background.colors[(target + 1) % Background.colors.count]
            let currentColor = Background.colors[target]
            let background = node as! SKShapeNode
            var cRed: CGFloat = 0, cGreen: CGFloat = 0, cBlue: CGFloat = 0
            var tRed: CGFloat = 0, tGreen: CGFloat = 0, tBlue: CGFloat = 0
            
            currentColor.getRed(&cRed, green: &cGreen, blue: &cBlue, alpha: nil)
            targetColor.getRed(&tRed, green: &tGreen, blue: &tBlue, alpha: nil)
            
            let t = clamp(a: 0.0, b: 1.0, v: elapsedTime/CGFloat(Background.colorDuration))
            let r = lerp(a: cRed, b: tRed, t: t) * 0.5
            let g = lerp(a: cGreen, b: tGreen, t: t) * 0.5
            let b = lerp(a: cBlue, b: tBlue, t: t) * 0.5
            
            background.fillColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        }
        
        self.run(action) {
            self.animate(target: (target + 1) % Background.colors.count)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

func lerp(a: CGFloat, b: CGFloat, t: CGFloat) -> CGFloat {
    return (1.0 - t) * a + t * b
}

func clamp(a: CGFloat, b: CGFloat, v: CGFloat) -> CGFloat {
    return v < a ? a : (v > b ? b : v)
}
