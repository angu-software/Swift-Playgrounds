import UIKit

public typealias Snapshot = UIImage

extension Snapshot {

    public var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}
