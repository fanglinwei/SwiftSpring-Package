import XCTest
@testable import SwiftSpring

#if canImport(UIKit)
import UIKit
#endif

final class SwiftSpringTests: XCTestCase {
    func testConfigUsesDocumentedDefaults() {
        let config = Config()

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

    #if canImport(UIKit)
    func testSetConfigPersistsForUIViewWrapper() {
        let view = UIView()

        view.spring.set { config in
            config.force = 2
            config.animation = .jump
        }

        view.spring.set { config in
            XCTAssertEqual(config.force, 2)
            XCTAssertEqual(config.animation, .jump)
        }
    }

    func testPointUpdatesTranslationConfig() {
        let view = UIView()

        view.spring.point(12, -8)

        view.spring.set { config in
            XCTAssertEqual(config.x, 12)
            XCTAssertEqual(config.y, -8)
        }
    }
    #endif

    static var allTests = [
        ("testConfigUsesDocumentedDefaults", testConfigUsesDocumentedDefaults),
    ]
}
