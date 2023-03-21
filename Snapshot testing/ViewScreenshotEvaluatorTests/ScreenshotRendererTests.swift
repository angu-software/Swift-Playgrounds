//
//  ScreenshotRendererTests.swift
//  ViewScreenshotEvaluatorTests
//
//  Created by Andreas Guenther on 06.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import XCTest

@testable import ViewScreenshotEvaluator

final class ScreenshotRendererTests: XCTestCase {

    func test_render_screenshot() {
        let scale: CGFloat = 1
        let view = makeTestView()

        let renderer = ScreenshotRenderer(scale: scale)
        let viewScreenshot = renderer.renderScreenshot(of: view)

        guard let referenceScreenshot = makeReferenceScreenshot(imageName: "viewGreen10x10.png") else {
            XCTFail("Failed to load reference screenshot")
            return
        }

        XCTAssertEqual(viewScreenshot, referenceScreenshot)
    }

    func test_render_screenshot_2x() {
        let scale: CGFloat = 2
        let view = makeTestView()

        let renderer = ScreenshotRenderer(scale: scale)
        let viewScreenshot = renderer.renderScreenshot(of: view)

        guard let referenceScreenshot = makeReferenceScreenshot(imageName: "viewGreen10x10@2x.png") else {
            XCTFail("Failed to load reference screenshot")
            return
        }

        XCTAssertEqual(viewScreenshot, referenceScreenshot)
    }

    func test_render_screenshot_3x() {
        let scale: CGFloat = 3
        let view = makeTestView()

        let renderer = ScreenshotRenderer(scale: scale)
        let viewScreenshot = renderer.renderScreenshot(of: view)

        guard let referenceScreenshot = makeReferenceScreenshot(imageName: "viewGreen10x10@3x.png") else {
            XCTFail("Failed to load reference screenshot")
            return
        }

        XCTAssertEqual(viewScreenshot, referenceScreenshot)
    }

    func test_diff_screenshot() {
        guard let viewScreenshot1x = makeReferenceScreenshot(imageName: "viewGreen10x10.png"),
            let viewScreenshot2x = makeReferenceScreenshot(imageName: "viewGreen10x10@2x.png") else {
                XCTFail("Test images not loaded")
                return
        }

        guard let referenceDiff = makeReferenceScreenshot(imageName: "viewGreenDiff.png") else {
            XCTFail("Failed to load reference diff screenshot")
            return
        }

        let renderer = ScreenshotRenderer(scale: 1)
        let diffScreenshot = renderer.makeDiffScreenshot(screenshot: viewScreenshot1x,
                                                         otherScreenshot: viewScreenshot2x)

        XCTAssertEqual(diffScreenshot, referenceDiff)
    }

    // MARK: Private

    private func makeTestView() -> UIView {
        let view = UIView()
        view.frame = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        view.backgroundColor = .green
        return view
    }

    private func makeReferenceScreenshot(imageName: String) -> Screenshot? {
        // For some reason loading this resource image from the test bundle fails. the loaded image will have way more bytes than the loaded image form the actual path on disc.
        // But actually this is exactly what we would do in the end in ScreenshotTests. Loading reference images from the local disc.
        var url = Tests.resourcesURL
        url.appendPathComponent(imageName)

        return Screenshot(contentsOf: url)
    }
}
