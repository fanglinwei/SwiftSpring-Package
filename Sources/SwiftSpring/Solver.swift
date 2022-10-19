//
//  Solver.swift
//  SpringAnimation
//
//  Created by calm on 2019/7/26.
//  Copyright © 2019 calm. All rights reserved.
//

import UIKit

class Solver: NSObject {
    
    let config: Config
    let view: UIView
    
    init(_ config: Config, _ view: UIView) {
        self.config = config
        self.view = view
        super.init()
    }
}

extension Solver {
    
    func animate(completion: (() -> Void)? = .none) {
        animatePreset()
        set(view: completion)
    }
}

extension Solver {
    
    private var animation: Animation.Preset { config.animation}
    private var force: CGFloat { config.force }
    private var delay: TimeInterval { config.delay }
    private var duration: TimeInterval { config.duration }
    private var damping: CGFloat { config.damping }
    private var velocity: CGFloat { config.velocity }
    private var repeatCount: Float { config.repeatCount }
    private var x: CGFloat { config.x }
    private var y: CGFloat { config.y }
    private var scaleX: CGFloat { config.scaleX }
    private var scaleY: CGFloat { config.scaleY }
    private var rotate: CGFloat { config.rotate }
    private var opacity: CGFloat { config.opacity }
    private var animateFrom: Bool { config.animateFrom }
    private var curve: Animation.Curve { config.curve }
    
    // UIView
    private var layer: CALayer { view.layer }
    private var transform: CGAffineTransform {
        get { view.transform }
        set { view.transform = newValue }
    }
    private var alpha: CGFloat {
        get { view.alpha }
        set { view.alpha = newValue }
    }
}

extension Solver {
    
    private func animatePreset() {
        view.alpha = 0.99
        switch animation {
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
            
        case .fadeOutIn:
            let animation = CABasicAnimation()
            animation.keyPath = "opacity"
            animation.fromValue = 1
            animation.toValue = 0
            animation.timingFunction = curve.timingFunction
            animation.duration = duration
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            animation.autoreverses = true
            layer.add(animation, forKey: "fade")
            
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
            
        case .shake:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "position.x"
            animation.values = [0, 30 * force, -30 * force, 30 * force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.timingFunction = curve.timingFunction
            animation.duration = duration
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "shake")
            
        case .bounce:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "position.y"
            animation.values = [0, -40 * force, 0, -20 * force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.timingFunction = curve.timingFunction
            animation.duration = duration
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "bounce")
            
        case .pop:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.scale"
            animation.values = [0, 0.2*force, -0.2*force, 0.2*force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.timingFunction = curve.timingFunction
            animation.duration = duration
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "pop")
            
        case .flipX:
            config.rotate = 0
            config.scaleX = 1
            config.scaleY = 1
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / layer.frame.size.width/2
            
            let animation = CABasicAnimation()
            animation.keyPath = "transform"
            animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 0, 0))
            animation.toValue = NSValue(caTransform3D:
                CATransform3DConcat(perspective, CATransform3DMakeRotation(.pi, 0, 1, 0)))
            animation.duration = duration
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            animation.timingFunction = curve.timingFunction
            layer.add(animation, forKey: "3d")
            
        case .flipY:
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / layer.frame.size.width / 2
            
            let animation = CABasicAnimation()
            animation.keyPath = "transform"
            animation.fromValue = NSValue(caTransform3D:
                CATransform3DMakeRotation(0, 0, 0, 0))
            animation.toValue = NSValue(caTransform3D:
                CATransform3DConcat(perspective, CATransform3DMakeRotation(.pi, 1, 0, 0)))
            animation.duration = duration
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            animation.timingFunction = curve.timingFunction
            layer.add(animation, forKey: "3d")
            
        case .morph:
            let morphX = CAKeyframeAnimation()
            morphX.keyPath = "transform.scale.x"
            morphX.values = [1, 1.3 * force, 0.7, 1.3 * force, 1]
            morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphX.timingFunction = curve.timingFunction
            morphX.duration = duration
            morphX.repeatCount = repeatCount
            morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphX, forKey: "morphX")
            
            let morphY = CAKeyframeAnimation()
            morphY.keyPath = "transform.scale.y"
            morphY.values = [1, 0.7, 1.3 * force, 0.7, 1]
            morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphY.timingFunction = curve.timingFunction
            morphY.duration = duration
            morphY.repeatCount = repeatCount
            morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphY, forKey: "morphY")
            
        case .squeeze:
            let morphX = CAKeyframeAnimation()
            morphX.keyPath = "transform.scale.x"
            morphX.values = [1, 1.5 * force, 0.5, 1.5 * force, 1]
            morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphX.timingFunction = curve.timingFunction
            morphX.duration = duration
            morphX.repeatCount = repeatCount
            morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphX, forKey: "morphX")
            
            let morphY = CAKeyframeAnimation()
            morphY.keyPath = "transform.scale.y"
            morphY.values = [1, 0.5, 1, 0.5, 1]
            morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphY.timingFunction = curve.timingFunction
            morphY.duration = duration
            morphY.repeatCount = repeatCount
            morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphY, forKey: "morphY")
            
        case .flash:
            let animation = CABasicAnimation()
            animation.keyPath = "opacity"
            animation.fromValue = 1
            animation.toValue = 0
            animation.duration = duration
            animation.repeatCount = repeatCount * 2.0
            animation.autoreverses = true
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "flash")
            
        case .wobble:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.rotation"
            animation.values = [0, 0.3 * force, -0.3 * force, 0.3 * force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.duration = duration
            animation.isAdditive = true
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "wobble")
            
            let x = CAKeyframeAnimation()
            x.keyPath = "position.x"
            x.values = [0, 30 * force, -30 * force, 30 * force, 0]
            x.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            x.timingFunction = curve.timingFunction
            x.duration = duration
            x.isAdditive = true
            x.repeatCount = repeatCount
            x.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(x, forKey: "x")
            
        case .swing:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.rotation"
            animation.values = [0, 0.3 * force, -0.3 * force, 0.3 * force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.duration = duration
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "swing")
            
        case .none:
            break
        }
    }
    
    private func set(view completion: (() -> Void)?) {
        
        func transformAnimate() {
            let translate = CGAffineTransform(translationX: x, y: y)
            let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
            let rotate = CGAffineTransform(rotationAngle: self.rotate)
            let translateAndScale = translate.concatenating(scale)
            transform = rotate.concatenating(translateAndScale)
            
            alpha = opacity
        }
        
        let animations =  { [weak self] in
            guard let self = self else { return }
            
            if self.animateFrom {
                self.transform = .identity
                self.alpha = 1
                
            } else {
                transformAnimate()
            }
        }
        
        if animateFrom {
            transformAnimate()
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(delay),
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: [curve.animationOptions, .allowUserInteraction],
            animations: animations
        ) { [weak self] finished in
            
            self?.resetAll()
            completion?()
        }
    }
}

extension Solver {
    
    private func reset() {
        config.x = 0
        config.y = 0
        config.opacity = 1
    }
    
    private func resetAll() {
        config.force = 1
        config.delay = 0
        config.duration = 0.7
        config.damping = 0.7
        config.velocity = 0.7
        config.repeatCount = 1
        config.x = 0
        config.y = 0
        config.scaleX = 1
        config.scaleY = 1
        config.rotate = 0
        config.animation = .none
        config.curve = .none
        config.opacity = 1
        config.animateFrom = true
    }
}
