//
//  ScreenshotEvaluatorTests.swift
//  ViewScreenshotEvaluatorTests
//
//  Created by Andreas Guenther on 07.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import XCTest

@testable import ViewScreenshotEvaluator

final class ScreenshotEvaluatorTests: XCTestCase {

    func test_recording() {
        let view = makeTestView()

        let evaluator = ScreenshotEvaluator(referenceImagesDirectoryURL: Tests.resourcesURL)
        evaluator.mode = .record

        let result = evaluator.evaluateView(view, on: .iPhoneSE, resizingViewTo: .sameSizeAsDevice)

        result.assert()
    }

    func test_evaluation() {
        let view = makeTestView()

        let evaluator = ScreenshotEvaluator(referenceImagesDirectoryURL: Tests.resourcesURL)

        let result = evaluator.evaluateView(view, on: .iPhoneSE, resizingViewTo: .sameSizeAsDevice)

        result.assert()
    }

    private func makeTestView() -> UIView {
        let view = UIView()
        view.backgroundColor = .red

        return view
    }
}

extension ScreenshotEvaluator.Result {

    func assert(file: StaticString = #file, line: UInt = #line) {
        switch self {
        case .success(.evaluation),
             .success(.recording):
            break // success
        case let .failure(.recording(error)):
            XCTFail("Failed to record screenshot. \(error.localizedDescription)", file: file, line: line)
        case .failure(.readingReferenceScreenshot):
            XCTFail("Failed to read reference screenshot.", file: file, line: line)
        case .failure(.storingFailureDiff),
             .failure(.creatingDiffScreenshot):
            XCTFail("Failed to create failure diff.", file: file, line: line)
        case .failure(.evaluation):
            XCTFail("Evaluation failed.", file: file, line: line) // TODO: improve
        }
    }
}
