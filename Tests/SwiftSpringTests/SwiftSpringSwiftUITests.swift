import XCTest
@testable import SwiftSpring

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
final class SwiftSpringSwiftUITests: XCTestCase {
    func testSpringConfigurationMatchesConfigDefaults() {
        let config = SpringConfiguration()

        XCTAssertEqual(config.animation, .none)
        XCTAssertEqual(config.curve, .none)
        XCTAssertEqual(config.force, 1)
        XCTAssertEqual(config.delay, 0)
        XCTAssertEqual(config.duration, 0.7)
        XCTAssertEqual(config.damping, 0.7)
        XCTAssertEqual(config.velocity, 0.7)
        XCTAssertEqual(config.repeatCount, 1)
        XCTAssertEqual(config.x, 0)
        XCTAssertEqual(config.y, 0)
        XCTAssertEqual(config.scaleX, 1)
        XCTAssertEqual(config.scaleY, 1)
        XCTAssertEqual(config.rotate, 0)
        XCTAssertEqual(config.opacity, 1)
        XCTAssertTrue(config.animateFrom)
    }

    func testEveryPresetProducesAtLeastOneFrame() {
        for preset in Animation.Preset.allCases {
            let frames = preset.springEffectFrames(configuration: SpringConfiguration())
            XCTAssertFalse(frames.isEmpty, "\(preset) should produce frames")
        }
    }

    func testFadeOutEndsTransparent() {
        let frames = Animation.Preset.fadeOut.springEffectFrames(configuration: SpringConfiguration())

        XCTAssertEqual(frames.last?.opacity, 0)
    }

    func testFlipXUsesYAxisRotation() {
        let frames = Animation.Preset.flipX.springEffectFrames(configuration: SpringConfiguration())

        XCTAssertEqual(frames.last?.rotation3DY, 1)
        XCTAssertEqual(frames.last?.rotation3DX, 0)
    }

    func testRepeatCountRepeatsKeyframes() {
        var config = SpringConfiguration()
        config.repeatCount = 2

        let repeatedFrames = Animation.Preset.shake.springEffectFrames(configuration: config)
        config.repeatCount = 1
        let singleFrames = Animation.Preset.shake.springEffectFrames(configuration: config)

        XCTAssertEqual(repeatedFrames.count, singleFrames.count * 2)
    }

    func testViewSpringModifierCompiles() {
        let view = Text("SwiftSpring").spring(.pop, trigger: true)

        XCTAssertNotNil(view)
    }

    func testCustomCurveMapsToSwiftUIAnimation() {
        let animation = Animation.Curve.custom(c1x: 0.1, c1y: 0.2, c2x: 0.3, c2y: 0.4)
            .swiftUIAnimation(duration: 0.5)

        XCTAssertNotNil(animation)
    }
}
#endif
