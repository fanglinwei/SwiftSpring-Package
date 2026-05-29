//
//  SpringConfiguration.swift
//  SwiftSpring
//
//  Created by OpenAI on 2026/5/29.
//

import CoreGraphics
import Foundation

public struct SpringConfiguration: Equatable {
    public var animation: Animation.Preset
    public var curve: Animation.Curve
    public var force: CGFloat
    public var delay: TimeInterval
    public var duration: TimeInterval
    public var damping: CGFloat
    public var velocity: CGFloat
    public var repeatCount: Float
    public var x: CGFloat
    public var y: CGFloat
    public var scaleX: CGFloat
    public var scaleY: CGFloat
    public var rotate: CGFloat
    public var opacity: CGFloat
    public var animateFrom: Bool

    public init(animation: Animation.Preset = .none,
                curve: Animation.Curve = .none,
                force: CGFloat = 1,
                delay: TimeInterval = 0,
                duration: TimeInterval = 0.7,
                damping: CGFloat = 0.7,
                velocity: CGFloat = 0.7,
                repeatCount: Float = 1,
                x: CGFloat = 0,
                y: CGFloat = 0,
                scaleX: CGFloat = 1,
                scaleY: CGFloat = 1,
                rotate: CGFloat = 0,
                opacity: CGFloat = 1,
                animateFrom: Bool = true) {
        self.animation = animation
        self.curve = curve
        self.force = force
        self.delay = delay
        self.duration = duration
        self.damping = damping
        self.velocity = velocity
        self.repeatCount = repeatCount
        self.x = x
        self.y = y
        self.scaleX = scaleX
        self.scaleY = scaleY
        self.rotate = rotate
        self.opacity = opacity
        self.animateFrom = animateFrom
    }

    public init(config: Config) {
        self.init(
            animation: config.animation,
            curve: config.curve,
            force: config.force,
            delay: config.delay,
            duration: config.duration,
            damping: config.damping,
            velocity: config.velocity,
            repeatCount: config.repeatCount,
            x: config.x,
            y: config.y,
            scaleX: config.scaleX,
            scaleY: config.scaleY,
            rotate: config.rotate,
            opacity: config.opacity,
            animateFrom: config.animateFrom
        )
    }

    public static let `default` = SpringConfiguration()

    func applying(_ preset: Animation.Preset) -> SpringConfiguration {
        var config = self
        config.animation = preset

        switch preset {
        case .slideLeft:
            config.x = 300 * force
        case .slideRight:
            config.x = -300 * force
        case .slideDown:
            config.y = -300 * force
        case .slideUp:
            config.y = 300 * force
        case .squeezeLeft:
            config.x = 300
            config.scaleX = 3 * force
        case .squeezeRight:
            config.x = -300
            config.scaleX = 3 * force
        case .squeezeDown:
            config.y = -300
            config.scaleY = 3 * force
        case .squeezeUp:
            config.y = 300
            config.scaleY = 3 * force
        case .fadeIn:
            config.opacity = 0
        case .fadeOut:
            config.opacity = 0
            config.animateFrom = false
        case .fadeInLeft:
            config.opacity = 0
            config.x = 300 * force
        case .fadeInRight:
            config.opacity = 0
            config.x = -300 * force
        case .fadeInDown:
            config.opacity = 0
            config.y = -300 * force
        case .fadeInUp:
            config.opacity = 0
            config.y = 300 * force
        case .zoomIn:
            config.opacity = 0
            config.scaleX = 2 * force
            config.scaleY = 2 * force
        case .zoomOut:
            config.opacity = 0
            config.scaleX = 2 * force
            config.scaleY = 2 * force
            config.animateFrom = false
        case .fall:
            config.rotate = 15 * (.pi / 180.0)
            config.y = 600 * force
            config.animateFrom = false
        case .flipX:
            config.rotate = 0
            config.scaleX = 1
            config.scaleY = 1
        case .flipY,
             .fadeOutIn,
             .shake,
             .bounce,
             .jump,
             .pop,
             .morph,
             .squeeze,
             .flash,
             .wobble,
             .swing,
             .none:
            break
        }

        return config
    }
}
