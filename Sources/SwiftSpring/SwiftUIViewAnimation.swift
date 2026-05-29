//
//  SwiftUIViewAnimation.swift
//  SwiftSpring
//
//  Created by OpenAI on 2026/5/29.
//

#if canImport(SwiftUI)
import Combine
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SwiftSpringModifier<Trigger: Equatable>: ViewModifier {
    private let preset: Animation.Preset
    private let trigger: Trigger
    private let configuration: SpringConfiguration

    @State private var frame = SpringEffectFrame.identity
    @State private var previousTrigger: Trigger?
    @State private var animationRun = 0

    public init(preset: Animation.Preset,
                trigger: Trigger,
                configuration: SpringConfiguration) {
        self.preset = preset
        self.trigger = trigger
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .offset(x: frame.offsetX, y: frame.offsetY)
            .scaleEffect(x: frame.scaleX, y: frame.scaleY)
            .rotationEffect(.radians(Double(frame.rotation)))
            .rotation3DEffect(
                .radians(Double(frame.rotation3DAngle)),
                axis: (x: frame.rotation3DX, y: frame.rotation3DY, z: frame.rotation3DZ)
            )
            .opacity(frame.opacity)
            .onReceive(Just(trigger)) { value in
                guard self.previousTrigger != value else { return }
                self.previousTrigger = value
                self.animate()
            }
    }

    private func animate() {
        animationRun += 1
        let currentRun = animationRun
        let frames = preset.springEffectFrames(configuration: configuration)
        guard !frames.isEmpty else { return }

        frame = frames[0]
        let repeatCount = max(1, Int(configuration.repeatCount.rounded(.down)))
        let singleFrameCount = max(1, frames.count / repeatCount)
        let frameDuration = configuration.duration / Double(max(singleFrameCount - 1, 1))

        for index in frames.indices.dropFirst() {
            let delay = configuration.delay + frameDuration * Double(index - 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard self.animationRun == currentRun else { return }
                withAnimation(self.configuration.curve.swiftUIAnimation(duration: frameDuration)) {
                    self.frame = frames[index]
                }
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func spring<Trigger: Equatable>(
        _ preset: Animation.Preset,
        trigger: Trigger,
        configuration: SpringConfiguration = .default
    ) -> some View {
        modifier(SwiftSpringModifier(preset: preset, trigger: trigger, configuration: configuration))
    }

    func spring<Trigger: Equatable>(
        _ preset: Animation.Preset,
        trigger: Trigger,
        force: CGFloat = 1,
        duration: TimeInterval = 0.7,
        delay: TimeInterval = 0,
        curve: Animation.Curve = .none
    ) -> some View {
        spring(
            preset,
            trigger: trigger,
            configuration: SpringConfiguration(
                animation: preset,
                curve: curve,
                force: force,
                delay: delay,
                duration: duration
            )
        )
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation.Curve {
    func swiftUIAnimation(duration: TimeInterval) -> SwiftUI.Animation {
        switch self {
        case .linear:
            return .linear(duration: duration)
        case .easeIn:
            return .easeIn(duration: duration)
        case .easeOut:
            return .easeOut(duration: duration)
        case .easeInOut:
            return .easeInOut(duration: duration)
        case .spring(let damping):
            return .interpolatingSpring(stiffness: 170, damping: Double(max(damping, 0.01)) * 20)
        case .discrete:
            return .timingCurve(1, 0, 1, 1, duration: duration)
        case .easeInSine:
            return .timingCurve(0.47, 0, 0.745, 0.715, duration: duration)
        case .easeOutSine:
            return .timingCurve(0.39, 0.575, 0.565, 1, duration: duration)
        case .easeInOutSine:
            return .timingCurve(0.445, 0.05, 0.55, 0.95, duration: duration)
        case .easeInQuad:
            return .timingCurve(0.55, 0.085, 0.68, 0.53, duration: duration)
        case .easeOutQuad:
            return .timingCurve(0.25, 0.46, 0.45, 0.94, duration: duration)
        case .easeInOutQuad:
            return .timingCurve(0.455, 0.03, 0.515, 0.955, duration: duration)
        case .easeInCubic:
            return .timingCurve(0.55, 0.055, 0.675, 0.19, duration: duration)
        case .easeOutCubic:
            return .timingCurve(0.215, 0.61, 0.355, 1, duration: duration)
        case .easeInOutCubic:
            return .timingCurve(0.645, 0.045, 0.355, 1, duration: duration)
        case .easeInQuart:
            return .timingCurve(0.895, 0.03, 0.685, 0.22, duration: duration)
        case .easeOutQuart:
            return .timingCurve(0.165, 0.84, 0.44, 1, duration: duration)
        case .easeInOutQuart:
            return .timingCurve(0.77, 0, 0.175, 1, duration: duration)
        case .easeInQuint:
            return .timingCurve(0.755, 0.05, 0.855, 0.06, duration: duration)
        case .easeOutQuint:
            return .timingCurve(0.23, 1, 0.32, 1, duration: duration)
        case .easeInOutQuint:
            return .timingCurve(0.86, 0, 0.07, 1, duration: duration)
        case .easeInExpo:
            return .timingCurve(0.95, 0.05, 0.795, 0.035, duration: duration)
        case .easeOutExpo:
            return .timingCurve(0.19, 1, 0.22, 1, duration: duration)
        case .easeInOutExpo:
            return .timingCurve(1, 0, 0, 1, duration: duration)
        case .easeInCirc:
            return .timingCurve(0.6, 0.04, 0.98, 0.335, duration: duration)
        case .easeOutCirc:
            return .timingCurve(0.075, 0.82, 0.165, 1, duration: duration)
        case .easeInOutCirc:
            return .timingCurve(0.785, 0.135, 0.15, 0.86, duration: duration)
        case .easeInBack:
            return .timingCurve(0.6, -0.28, 0.735, 0.045, duration: duration)
        case .easeOutBack:
            return .timingCurve(0.175, 0.885, 0.32, 1.275, duration: duration)
        case .easeInOutBack:
            return .timingCurve(0.68, -0.55, 0.265, 1.55, duration: duration)
        case let .custom(c1x, c1y, c2x, c2y):
            return .timingCurve(Double(c1x), Double(c1y), Double(c2x), Double(c2y), duration: duration)
        default:
            return .easeInOut(duration: duration)
        }
    }
}

#endif
