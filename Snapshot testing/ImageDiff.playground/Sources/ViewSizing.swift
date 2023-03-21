import UIKit

public struct Sizing {

    public enum Strategy {
        case compressed
        case expanded
        case fixed(value: CGFloat)

        var fittingPriority: UILayoutPriority {
            switch self {
            case .fixed:
                return .required
            case .compressed, .expanded:
                return .fittingSizeLevel
            }
        }
    }

    let width: Strategy
    let height: Strategy

    var targetSize: CGSize {
        let targetWidth: CGFloat
        switch width {
        case let .fixed(value):
            targetWidth = value
        case .compressed:
            targetWidth = compressedReferenceSize.width
        case .expanded:
            targetWidth = expandedReferenceSize.width
        }

        let targetHeight: CGFloat
        switch height {
        case let .fixed(value):
            targetHeight = value
        case .compressed:
            targetHeight = compressedReferenceSize.height
        case .expanded:
            targetHeight = expandedReferenceSize.height
        }

        return CGSize(width: targetWidth,
                      height: targetHeight)
    }

    private let compressedReferenceSize = UIView.layoutFittingCompressedSize
    private let expandedReferenceSize = UIView.layoutFittingExpandedSize

    public init(width: Strategy, height: Strategy) {
        self.width = width
        self.height = height
    }
}

extension UIView {

    public func size(for sizing: Sizing) -> CGSize {
        return systemLayoutSizeFitting(sizing.targetSize,
                                       withHorizontalFittingPriority: sizing.width.fittingPriority,
                                       verticalFittingPriority: sizing.height.fittingPriority)
    }

    public func applySizing(_ sizing: Sizing) {
        frame.size = size(for: sizing)
    }
}
