//
//  Wrapper.swift
//  SpringAnimation
//
//  Created by calm on 2019/7/26.
//  Copyright © 2019 calm. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public struct Wrapper<Base> {
    
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

public protocol AnimationCompatible {}

public extension AnimationCompatible {
    
    var spring: Wrapper<Self> { Wrapper(self) }
}

extension UIView: AnimationCompatible {}

#endif
