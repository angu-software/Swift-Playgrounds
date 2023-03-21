//
//  Device.swift
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 03.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import UIKit

// TODO: Take scaling into account?
/// - See Also: [Ultimate Guide to iPhone resolutions]( https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions)
enum Device {
    case current
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhone11Pro
    case iPhone11
    case iPhone11ProMax

    var name: String {
        switch self {
        case .current:
            return UIDevice.current.name
        default:
            return "\(self)"
        }
    }

    var size: CGSize {
        switch self {
        case .current:
            return UIScreen.main.bounds.size
        case .iPhoneSE:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11,
             .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        }
    }

    var scale: CGFloat {
        switch self {
        case .current:
            return UIScreen.main.scale
        case .iPhoneSE,
             .iPhone8,
             .iPhone11:
            return 2
        case .iPhone8Plus,
             .iPhone11Pro,
             .iPhone11ProMax:
            return 3
        }
    }
}
