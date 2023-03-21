//
//  ScreenshotFileManager.swift
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 07.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import Foundation

final class ScreenshotFileManager {

    private let fileManager = FileManager()

    func writeScreenshot(_ screenshot: Screenshot, to url: URL) throws {
        try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try screenshot.pngData.write(to: url)
    }
}
