//
//  ScreenshotEvaluator.swift
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 03.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import UIKit

final class ScreenshotEvaluator {

    typealias Result = Swift.Result<Success, Failure>

    enum Success {
        case recording
        case evaluation
    }

    enum Failure: Error {
        case recording(Error)
        case readingReferenceScreenshot
        case storingFailureDiff
        case creatingDiffScreenshot
        case evaluation
    }

    enum Mode {
        case record
        case evaluate
    }

    var mode: Mode = .evaluate

    private let referenceImagesDirectoryURL: URL // static

    private let fileManager = ScreenshotFileManager()

    init(referenceImagesDirectoryURL: URL) {
        self.referenceImagesDirectoryURL = referenceImagesDirectoryURL
    }

    func evaluateView(_ view: UIView,
                      on device: Device,
                      resizingViewTo viewSizing: ViewSizing = .useAsIs,
                      screenshotId: String? = nil,
                      file: StaticString = #file,
                      method: StaticString = #function) -> Result {

        print(UIScreen.main.scale)

        let screenshotURLs = ScreenshotURLComponents(baseURL: referenceImagesDirectoryURL,
                                                     filePath: file,
                                                     method: method,
                                                     device: device,
                                                     screenshotId: screenshotId)

        view.applyViewSizing(viewSizing, for: device)

        let screenshotRenderer = ScreenshotRenderer(scale: device.scale)
        let screenshot = screenshotRenderer.renderScreenshot(of: view)

        switch mode {
        case .record:
            return recordScreenshot(screenshot, writeTo: screenshotURLs.referenceScreenshotURL)
        case .evaluate:
            guard let referenceScreenshot = Screenshot(contentsOf: screenshotURLs.referenceScreenshotURL) else {
                return .failure(.readingReferenceScreenshot)
            }

            if screenshot == referenceScreenshot {
                return .success(.evaluation)
            }

            return createFailureDiff(for: screenshot,
                                     diffingWith: referenceScreenshot,
                                     screenshotRenderer: screenshotRenderer,
                                     screenshotURLs: screenshotURLs)
        }
    }

    private func recordScreenshot(_ screenshot: Screenshot, writeTo url: URL) -> Result {
        do {
            try fileManager.writeScreenshot(screenshot, to: url)
            return .success(.recording)
        } catch {
            return .failure(.recording(error))
        }
    }

    private func createFailureDiff(for screenshot: Screenshot,
                                   diffingWith referenceScreenshot: Screenshot,
                                   screenshotRenderer: ScreenshotRenderer,
                                   screenshotURLs: ScreenshotURLComponents) -> Result {
        guard let diffScreenshot = screenshotRenderer.makeDiffScreenshot(screenshot: referenceScreenshot,
                                                                         otherScreenshot: screenshot) else {
                                                                            return .failure(.creatingDiffScreenshot)
        }

        do {
            try fileManager.writeScreenshot(diffScreenshot, to: screenshotURLs.failureDiffScreenshotURL)
            try fileManager.writeScreenshot(screenshot, to: screenshotURLs.failureFailureScreenshotURL)
            try fileManager.writeScreenshot(referenceScreenshot, to: screenshotURLs.failureReferenceScreenshotURL)
            return .failure(.evaluation)
        } catch {
            return .failure(.storingFailureDiff)
        }
    }
}

extension UIView {

    // TODO: try to figure out if `snapshotView(afterScreenUpdates: true)` will actually do the same
    fileprivate func applyViewSizing(_ viewSizing: ViewSizing, for device: Device) {
        snapshotView(afterScreenUpdates: true)
        switch viewSizing {
        case .useAsIs:
            break
        case .intrinsic: // TODO: intrinsic sizes for height and width only
            frame = CGRect(origin: .zero, size: systemLayoutSizeFitting(UIView.layoutFittingCompressedSize))
        case let .custom(size):
            frame = CGRect(origin: .zero, size: size)
        case .sameSizeAsDevice:
            frame = CGRect(origin: .zero, size: device.size)
        }
        layoutIfNeeded()
    }
}
