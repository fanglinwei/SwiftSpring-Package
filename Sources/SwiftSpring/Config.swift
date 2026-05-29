//
//  Config.swift
//  SpringAnimation
//
//  Created by calm on 2019/7/26.
//  Copyright © 2019 calm. All rights reserved.
//

import CoreGraphics
import Foundation

public class Config {
    public var animation: Animation.Preset = .none
    public var curve: Animation.Curve = .none
    public var force: CGFloat = 1
    public var delay: TimeInterval = 0
    public var duration: TimeInterval = 0.7
    public var damping: CGFloat = 0.7
    public var velocity: CGFloat = 0.7
    public var repeatCount: Float = 1
    public var x: CGFloat = 0
    public var y: CGFloat = 0
    public var scaleX: CGFloat = 1
    public var scaleY: CGFloat = 1
    public var rotate: CGFloat = 0
    public var opacity: CGFloat = 1
    public var animateFrom: Bool = true
    
    public init() {}

    init(copying config: Config) {
        animation = config.animation
        curve = config.curve
        force = config.force
        delay = config.delay
        duration = config.duration
        damping = config.damping
        velocity = config.velocity
        repeatCount = config.repeatCount
        x = config.x
        y = config.y
        scaleX = config.scaleX
        scaleY = config.scaleY
        rotate = config.rotate
        opacity = config.opacity
        animateFrom = config.animateFrom
    }
}
