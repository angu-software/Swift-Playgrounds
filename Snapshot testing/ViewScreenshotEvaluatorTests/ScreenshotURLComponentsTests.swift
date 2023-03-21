//
//  SnapshotImageComponents.swift
//  ViewScreenshotEvaluatorTests
//
//  Created by Andreas Guenther on 03.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import XCTest

@testable import ViewScreenshotEvaluator

final class ScreenshotURLComponentsTests: XCTestCase {

    func test_screenshot_URL() {
        let baseURL = URL(fileURLWithPath: "/View Screenshots", isDirectory: true)
        let urlComponents = ScreenshotURLComponents(baseURL: baseURL,
                                                    filePath: #file,
                                                    method: #function,
                                                    device: .iPhone11ProMax,
                                                    screenshotId: "someId")

        XCTAssertEqual(urlComponents.referenceScreenshotURL.path, "/View Screenshots/Reference Screenshots/ScreenshotURLComponentsTests/test_screenshot_URL()_viewScreenshot(someId)_on_iPhone11ProMax(414x896@3x)_reference.png")
        XCTAssertEqual(urlComponents.failureDiffScreenshotURL.path, "/View Screenshots/Failure Diffs/ScreenshotURLComponentsTests/test_screenshot_URL()_viewScreenshot(someId)_on_iPhone11ProMax(414x896@3x)_diff.png")
        XCTAssertEqual(urlComponents.failureFailureScreenshotURL.path, "/View Screenshots/Failure Diffs/ScreenshotURLComponentsTests/test_screenshot_URL()_viewScreenshot(someId)_on_iPhone11ProMax(414x896@3x)_failure.png")
        XCTAssertEqual(urlComponents.failureReferenceScreenshotURL.path, "/View Screenshots/Failure Diffs/ScreenshotURLComponentsTests/test_screenshot_URL()_viewScreenshot(someId)_on_iPhone11ProMax(414x896@3x)_reference.png")
    }
}
