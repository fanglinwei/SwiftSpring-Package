//
//  SwiftUIPresetState.swift
//  SwiftSpring
//
//  Created by OpenAI on 2026/5/29.
//

import CoreGraphics
import Foundation

struct SpringEffectFrame: Equatable {
    var offsetX: CGFloat
    var offsetY: CGFloat
    var scaleX: CGFloat
    var scaleY: CGFloat
    var rotation: CGFloat
    var opacity: Double
    var rotation3DAngle: CGFloat
    var rotation3DX: CGFloat
    var rotation3DY: CGFloat
    var rotation3DZ: CGFloat

    init(offsetX: CGFloat = 0,
         offsetY: CGFloat = 0,
         scaleX: CGFloat = 1,
         scaleY: CGFloat = 1,
         rotation: CGFloat = 0,
         opacity: Double = 1,
         rotation3DAngle: CGFloat = 0,
         rotation3DX: CGFloat = 0,
         rotation3DY: CGFloat = 0,
         rotation3DZ: CGFloat = 0) {
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.scaleX = scaleX
        self.scaleY = scaleY
        self.rotation = rotation
        self.opacity = opacity
        self.rotation3DAngle = rotation3DAngle
        self.rotation3DX = rotation3DX
        self.rotation3DY = rotation3DY
        self.rotation3DZ = rotation3DZ
    }

    static let identity = SpringEffectFrame()
}

extension Animation.Preset {
    func springEffectFrames(configuration: SpringConfiguration) -> [SpringEffectFrame] {
        let configured = configuration.applying(self)
        let frames = baseFrames(configuration: configured)
        let repeatCount = max(1, Int(configured.repeatCount.rounded(.down)))

        guard repeatCount > 1 else { return frames }

        return (0..<repeatCount).flatMap { _ in frames }
    }

    private func baseFrames(configuration: SpringConfiguration) -> [SpringEffectFrame] {
        switch self {
        case .fadeOutIn:
            return [
                .identity,
                SpringEffectFrame(opacity: 0),
                .identity
            ]
        case .shake:
            return offsets(x: [0, 30, -30, 30, 0], force: configuration.force)
        case .bounce:
            return offsets(y: [0, -40, 0, -20, 0], force: configuration.force)
        case .jump:
            return [
                .identity,
                SpringEffectFrame(offsetY: -60 * configuration.force, scaleY: 0.88),
                SpringEffectFrame(offsetY: -12 * configuration.force, scaleY: 1.06),
                .identity
            ]
        case .pop:
            return scales([1, 1 + 0.2 * configuration.force, 1 - 0.2 * configuration.force, 1 + 0.2 * configuration.force, 1])
        case .flipX:
            return [
                .identity,
                SpringEffectFrame(rotation3DAngle: .pi, rotation3DY: 1)
            ]
        case .flipY:
            return [
                .identity,
                SpringEffectFrame(rotation3DAngle: .pi, rotation3DX: 1)
            ]
        case .morph:
            return [
                .identity,
                SpringEffectFrame(scaleX: 1.3 * configuration.force, scaleY: 0.7),
                SpringEffectFrame(scaleX: 0.7, scaleY: 1.3 * configuration.force),
                SpringEffectFrame(scaleX: 1.3 * configuration.force, scaleY: 0.7),
                .identity
            ]
        case .squeeze:
            return [
                .identity,
                SpringEffectFrame(scaleX: 1.5 * configuration.force, scaleY: 0.5),
                SpringEffectFrame(scaleX: 0.5, scaleY: 1),
                SpringEffectFrame(scaleX: 1.5 * configuration.force, scaleY: 0.5),
                .identity
            ]
        case .flash:
            return [
                .identity,
                SpringEffectFrame(opacity: 0),
                .identity
            ]
        case .wobble:
            return [
                .identity,
                SpringEffectFrame(offsetX: 30 * configuration.force, rotation: 0.3 * configuration.force),
                SpringEffectFrame(offsetX: -30 * configuration.force, rotation: -0.3 * configuration.force),
                SpringEffectFrame(offsetX: 30 * configuration.force, rotation: 0.3 * configuration.force),
                .identity
            ]
        case .swing:
            return [
                .identity,
                SpringEffectFrame(rotation: 0.3 * configuration.force),
                SpringEffectFrame(rotation: -0.3 * configuration.force),
                SpringEffectFrame(rotation: 0.3 * configuration.force),
                .identity
            ]
        case .none:
            return [.identity]
        default:
            return directionalFrames(configuration: configuration)
        }
    }

    private func directionalFrames(configuration: SpringConfiguration) -> [SpringEffectFrame] {
        let target = SpringEffectFrame(
            offsetX: configuration.x,
            offsetY: configuration.y,
            scaleX: configuration.scaleX,
            scaleY: configuration.scaleY,
            rotation: configuration.rotate,
            opacity: Double(configuration.opacity)
        )

        return configuration.animateFrom ? [target, .identity] : [.identity, target]
    }

    private func offsets(x values: [CGFloat] = [], y yValues: [CGFloat] = [], force: CGFloat) -> [SpringEffectFrame] {
        if !values.isEmpty {
            return values.map { SpringEffectFrame(offsetX: $0 * force) }
        }

        return yValues.map { SpringEffectFrame(offsetY: $0 * force) }
    }

    private func scales(_ values: [CGFloat]) -> [SpringEffectFrame] {
        values.map { SpringEffectFrame(scaleX: $0, scaleY: $0) }
    }
}
