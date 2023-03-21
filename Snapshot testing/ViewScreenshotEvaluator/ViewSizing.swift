//
//  ViewSizing.swift
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 03.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import CoreGraphics

enum ViewSizing {
    case useAsIs
    case intrinsic
    case custom(CGSize)
    case sameSizeAsDevice
}
