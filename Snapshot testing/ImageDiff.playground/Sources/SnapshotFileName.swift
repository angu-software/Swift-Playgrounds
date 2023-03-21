import CoreGraphics
import Foundation

public struct SnapshotFileName {

    let rawValue: String

    fileprivate init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public struct SnapshotFileNameComponents {

    public let name: String
    public let scale: CGFloat
    public var tag: String = ""
    public var identifier: String = ""

    public init(name: String, scale: CGFloat) {
        self.name = name
        self.scale = scale
    }

    public var fileName: SnapshotFileName {
        let scaleSuffix = scale > 1 ? String(format: "@%.0fx", scale) : ""

        let nameComponents = [name, tag, identifier].filter({ !$0.isEmpty })

        let rawName = nameComponents.joined(separator: "_") + scaleSuffix

        return SnapshotFileName(rawValue: rawName)
    }
}
