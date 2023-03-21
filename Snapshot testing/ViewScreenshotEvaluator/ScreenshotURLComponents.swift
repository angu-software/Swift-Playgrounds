//
//  ScreenshotURLComponents.swift
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 03.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import Foundation

// TODO: naming
struct ScreenshotURLComponents {

    private enum ImageType: String {
        case png
    }

    private enum ScreenshotType: String {
        case reference
        case diff
        case failure
    }

    private enum Folder: String {
        case referenceImages = "Reference Screenshots"
        case failureImages   = "Failure Diffs"
    }

    let baseURL: URL
    let filePath: StaticString
    let method: StaticString
    let device: Device
    let screenshotId: String?

    private let componentSeparator: String = "_"
    private let imageType: ImageType = .png

    init(baseURL: URL, filePath: StaticString, method: StaticString, device: Device, screenshotId: String? = nil) {
        self.baseURL = baseURL
        self.filePath = filePath
        self.method = method
        self.device = device
        self.screenshotId = screenshotId
    }

    var referenceScreenshotURL: URL {
        return makeScreenshotImageURL(folder: .referenceImages, screenshotType: .reference)
    }

    var failureDiffScreenshotURL: URL {
        return makeScreenshotImageURL(folder: .failureImages, screenshotType: .diff)
    }

    var failureFailureScreenshotURL: URL {
        return makeScreenshotImageURL(folder: .failureImages, screenshotType: .failure)
    }

    var failureReferenceScreenshotURL: URL {
        return makeScreenshotImageURL(folder: .failureImages, screenshotType: .reference)
    }
    
    private func makeScreenshotFileName(for screenshotType: ScreenshotType) -> String {
        var screenshotName = "viewScreenshot"
        if let screenShotId = screenshotId {
            screenshotName += "(\(screenShotId))"
        }
        let nameComponents = [String(staticString: method), screenshotName, "on" , device.imageFileNameComponent, screenshotType.rawValue]
        return nameComponents.compactMap({ $0 }).joined(separator: componentSeparator)
    }

    private func makeScreenshotImageURL(folder: Folder, screenshotType: ScreenshotType) -> URL {
        let fileURL = URL(fileURLWithPath: String(staticString: filePath))
          let fileName = fileURL.deletingPathExtension().lastPathComponent
          var referenceImageURL = URL(fileURLWithPath: "\(folder.rawValue)/\(fileName)", isDirectory: false, relativeTo: baseURL)
          referenceImageURL.deletePathExtension()
        referenceImageURL.appendPathComponent(makeScreenshotFileName(for: screenshotType))
          referenceImageURL.appendPathExtension(imageType.rawValue)

          return referenceImageURL.absoluteURL
    }
}

extension String {

    fileprivate init(staticString: StaticString) {
        self = staticString.withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        }
    }
}

extension Device {

    fileprivate var imageFileNameComponent: String {
        return String(format: "%@(%.0fx%.0f@%.0fx)", name, size.width, size.height, scale)
    }
}
