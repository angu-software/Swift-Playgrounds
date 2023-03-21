import PlaygroundSupport
import UIKit
import XCTest

nil == nil

final class ViewScreenshotEvaluator {

    enum Mode {
        case record
        case evaluate
    }

    enum Sizing {
        case useAsIs
        case intrinsic
        case custom(CGSize)
        case sameSizeAsDevice
    }

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

    private let referenceImagesDirectoryURL: URL

    init(referenceImagesDirectoryURL: URL) {
        self.referenceImagesDirectoryURL = referenceImagesDirectoryURL
    }

    func evaluateView(_ view: UIView, on device: Device, resizingViewTo viewSizing: Sizing = .useAsIs, viewId: String? = nil, file: StaticString = #file, method: StaticString = #function, line: UInt = #line) {

        // * make referenceImagePath

        // <referenceImagesDirectory>/<file>/<method>_[<viewId>_]<device>.png
        // <device>: <deviceName>(<deviceSize>)@<scale>x

        // * render image of view -> currentViewImage
        // * check if recording
        //   * store image of view at referenceImagePath
        // * load referenceImage
        // * compare images
        // * if not equal
        //   * create diff image
        //   * store rendered images at failurePath
    }

}

let sharedDir = playgroundSharedDataDirectory
print(sharedDir)

let bundle = Bundle.main
let resourcePath = bundle.resourcePath

let fileManager = FileManager()
let currentDir = fileManager.currentDirectoryPath
let tempDir = fileManager.temporaryDirectory
let sharedDirExists = fileManager.fileExists(atPath: sharedDir.path)

do {
    let downloadDir = try fileManager.contentsOfDirectory(at: sharedDir, includingPropertiesForKeys: nil, options: [])
} catch {
    print(error.localizedDescription)
}

let recordMode = true

let referenceImage = UIImage(named: "Kitten01.jpg")
let currentImage = UIImage(named: "Kitten02.jpg")

if recordMode,
    let referenceImage = referenceImage,
    let currentImage = currentImage,
    referenceImage.pngData() != currentImage.pngData() {
    let diffImage = makeDiffImage(referenceImage: referenceImage, currentImage: currentImage)
}



