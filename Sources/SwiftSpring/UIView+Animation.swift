//
//  UIView+Animation.swift
//  SpringAnimation
//
//  Created by calm on 2019/7/26.
//  Copyright © 2019 calm. All rights reserved.
//

import UIKit

// MARK: - 链式属性
public extension Wrapper where Base: UIView {
    
    @discardableResult
    func force(_ force: CGFloat) -> Wrapper {
        config.force = force
        return self
    }
    @discardableResult
    func delay(_ delay: TimeInterval) -> Wrapper {
        config.delay = delay
        return self
    }
    @discardableResult
    func duration(_ duration: TimeInterval) -> Wrapper {
        config.duration = duration
        return self
    }
    @discardableResult
    func damping(_ damping: CGFloat) -> Wrapper {
        config.damping = damping
        return self
    }
    @discardableResult
    func velocity(_ velocity: CGFloat) -> Wrapper {
        config.velocity = velocity
        return self
    }
    @discardableResult
    func repeatCount(_ repeatCount: Float) -> Wrapper {
        config.repeatCount = repeatCount
        return self
    }
    @discardableResult
    func potint(_ x: CGFloat, _ y: CGFloat) -> Wrapper {
        config.x = x
        config.y = y
        return self
    }
    @discardableResult
    func scale(_ x: CGFloat, _ y: CGFloat) -> Wrapper {
        config.scaleX = x
        config.scaleY = y
        return self
    }
    @discardableResult
    func rotate(_ rotate: CGFloat) -> Wrapper {
        config.rotate = rotate
        return self
    }
    @discardableResult
    func opacity(_ opacity: CGFloat) -> Wrapper {
        config.opacity = opacity
        return self
    }
    @discardableResult
    func animateFrom(_ animateFrom: Bool) -> Wrapper {
        config.animateFrom = animateFrom
        return self
    }
    @discardableResult
    func curve(_ curve: Animation.Curve) -> Wrapper {
        config.curve = curve
        return self
    }
    @discardableResult
    func animation(_ animation: Animation.Preset) -> Wrapper {
        config.animation = animation
        return self
    }
    // UIView
    @discardableResult
    func transform(_ transform: CGAffineTransform) -> Wrapper {
        base.transform = transform
        return self
    }
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Wrapper {
        base.alpha = alpha
        return self
    }
}

public extension Wrapper where Base: UIView {
    
    func animate(_ animation: Animation.Preset? = Optional.none,
                 completion: (() -> Void)? = .none) {
        animation.map { config.animation = $0 }
        solver.animate(completion: completion)
    }
}

private var taskSolverKey: Void?

extension Wrapper where Base: UIView {
    
    public func set(config: (Config) -> Void) {
        config(self.config)
    }
    
    private var config: Config { solver.config }
    
    private var solver: Solver {
        guard let solver = objc_getAssociatedObject(base, &taskSolverKey) as? Solver else {
            let value = Solver(Config(), base)
            objc_setAssociatedObject(base, &taskSolverKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return solver
    }
}
