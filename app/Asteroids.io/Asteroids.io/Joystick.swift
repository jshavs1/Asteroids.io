//
//  Joystick.swift
//  Asteroids.io
//
//  Created by Tony on 4/24/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import UIKit

@IBDesignable
class Joystick: UIView {
    
    @IBInspectable
    var joystickColor: UIColor? {
        didSet {
            joystickView.backgroundColor = joystickColor
        }
    }
    @IBInspectable
    var offset: CGFloat = 20 {
        didSet {
            layoutJoystick()
        }
    }
    @IBInspectable
    var smoothing: CGFloat = 0.05
    
    var radius: CGFloat {
        get {
            return bounds.width / 2
        }
    }
    var x: CGFloat {
        get {
            return ((currentPoint?.x ?? 0) / radius).roundTo(places: 2)
        }
    }
    var y: CGFloat {
        get {
            return (-(currentPoint?.y ?? 0) / radius).roundTo(places: 2)
        }
    }
    var magnitude: CGFloat {
        get {
            return sqrt(x*x + y*y)
        }
    }
    
    var currentPoint: CGPoint?
    var joystickView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupJoystick()
        layoutJoystick()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupJoystick()
        layoutJoystick()
    }
    
    func setupJoystick() {
        layer.cornerRadius = bounds.size.width / 2
        
        if (joystickView == nil) {
            joystickView = UIView()
            self.addSubview(joystickView)
        }
    }
    
    func layoutJoystick() {
        guard joystickView != nil else {return}
        
        joystickView.bounds.size = CGSize(width: bounds.size.width - offset, height: bounds.size.height - offset)
        joystickView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        joystickView.layer.cornerRadius = joystickView.bounds.width / 2
        
        joystickView.layoutIfNeeded()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupJoystick()
        layoutJoystick()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupJoystick()
        layoutJoystick()
    }
    
    func moveJoystick(to: CGPoint) {
        var rel = CGPoint(x: to.x - bounds.size.width / 2, y: to.y - bounds.size.height / 2)
        let dist = sqrt(rel.x*rel.x + rel.y*rel.y)
        if (dist > radius) {
            rel.x = rel.x * (radius / dist)
            rel.y = rel.y * (radius / dist)
        }
        
        currentPoint = rel
        UIView.animate(withDuration: TimeInterval(smoothing)) {
            self.joystickView.center = CGPoint(x: rel.x + self.bounds.size.width / 2, y: rel.y + self.bounds.size.height / 2)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let point = touch.location(in: self)
        moveJoystick(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let point = touch.location(in: self)
        moveJoystick(to: point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveJoystick(to: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2))
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
