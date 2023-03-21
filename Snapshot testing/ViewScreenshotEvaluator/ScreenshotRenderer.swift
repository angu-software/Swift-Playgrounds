//
//  ScreenshotRenderer.swift
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 03.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import UIKit

final class ScreenshotRenderer {

    private let scale: CGFloat

    init(scale: CGFloat) {
        self.scale = scale
    }

    func renderScreenshot(of view: UIView) -> Screenshot {
        let bounds = view.bounds
        let imageRenderer = makeUIGraphicsImageRenderer(bounds: bounds)
        let pngData = imageRenderer.pngData { ctx in
            view.layer.render(in: ctx.cgContext)
        }
        return Screenshot(pngData: pngData)
    }

    func makeDiffScreenshot(screenshot: Screenshot, otherScreenshot: Screenshot, blendAlpha: CGFloat = 0.8) -> Screenshot? {
        // TODO: optimize!
        guard let screenshotImage = screenshot.image,
            let otherScreenshotImage = otherScreenshot.image else {
                return nil
        }

        let diffImagePNGData = makeDiffImagePNGData(referenceImage: screenshotImage, otherImage: otherScreenshotImage)

        return Screenshot(pngData: diffImagePNGData)
    }

    private func makeDiffImagePNGData(referenceImage: UIImage, otherImage: UIImage, blendAlpha: CGFloat = 0.8) -> Data {
        let referenceImageBounds = CGRect(origin: .zero, size: referenceImage.size)
        let otherImageBounds = CGRect(origin: .zero, size: otherImage.size)
        let diffImageBounds = referenceImageBounds.union(otherImageBounds)

        let imageRenderer = makeUIGraphicsImageRenderer(bounds: diffImageBounds)

        let diffImagePNGData = imageRenderer.pngData { _ in
            referenceImage.draw(in: referenceImageBounds)
            otherImage.draw(in: otherImageBounds, blendMode: .difference, alpha: blendAlpha)
        }

        return diffImagePNGData
    }

    private func makeUIGraphicsImageRenderer(bounds: CGRect) -> UIGraphicsImageRenderer {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(bounds: bounds, format: format)
    }
}
