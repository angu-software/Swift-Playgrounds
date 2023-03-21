import UIKit

public final class SnapshotRenderer {

    private let imageRendererFormat = UIGraphicsImageRendererFormat()

    public init(scale: CGFloat) {
        imageRendererFormat.scale = scale
    }

    public func snapshot(of view: UIView) -> Snapshot {
        let imageRenderer = UIGraphicsImageRenderer(bounds: view.bounds, format: imageRendererFormat)

        let snapshot = imageRenderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        return snapshot
    }

    public func differenceSnapshot(of snapshot1: Snapshot, comparedTo snapshot2: Snapshot, differenceAlpha: CGFloat = 0.75) -> Snapshot {
        let drawingBounds = snapshot1.bounds.union(snapshot2.bounds)
        let imageRenderer = UIGraphicsImageRenderer(bounds: drawingBounds, format: imageRendererFormat)

        let snapshot = imageRenderer.image { _ in
            snapshot1.draw(at: .zero)
            snapshot2.draw(at: .zero, blendMode: .difference, alpha: differenceAlpha)
        }

        return snapshot
    }
}
