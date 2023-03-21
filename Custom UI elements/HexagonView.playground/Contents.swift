//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

final class ProgressBadgeView: UIView {

    var progress: CGFloat {
        get {
            return progressLayer.strokeEnd
        }
        set {
            progressLayer.strokeEnd = newValue
        }
    }

    var progressColor: UIColor = .blue {
        didSet {
            styleLayers()
        }
    }

    var progressBackgroundColor: UIColor = .lightGray {
        didSet {
            styleLayers()
        }
    }

    /// This icon will be centered in the view. Caller needs to set the size of that image accordingly before assigning
    /// Use `iconCenterOffset` to adjust the icons position in the view.
    var icon: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var iconBackgroundColor: UIColor = .blue {
        didSet {
            styleLayers()
        }
    }

    var iconCenterOffset: CGPoint = .zero {
        didSet {
            styleLayers()
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            styleLayers()
        }
    }

    private let progressLineWith: CGFloat = 4
    private let progressImageSpacing: CGFloat = 4
    private let cornerRadius: CGFloat = 8

    private let imageView = UIImageView()

    private let progressBGLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let progressCoverLayer = CAShapeLayer()
    private let iconBGLayer = CAShapeLayer()
    private var badgeLayer = CALayer()

    init(diameter: CGFloat) {
        let frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        super.init(frame: frame)

        progressLayer.strokeEnd = 0
        imageView.frame = frame
        imageView.contentMode = .center

        addSubview(imageView)

        styleLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func styleLayers() {
        progressBGLayer.strokeColor = progressBackgroundColor.cgColor
        progressBGLayer.lineWidth = progressLineWith

        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = progressBackgroundColor.cgColor
        progressLayer.lineWidth = progressLineWith

        progressCoverLayer.fillColor = backgroundColor?.cgColor

        iconBGLayer.fillColor = iconBackgroundColor.cgColor
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        badgeLayer.removeFromSuperlayer()
        badgeLayer = makeBadgeLayer(frame: layer.frame)
        layer.addSublayer(badgeLayer)
    }

    private func makeBadgeLayer(frame: CGRect) -> CALayer {

        progressBGLayer.frame = frame
        progressBGLayer.path = makeHexagonPath(frame: layer.frame)?.cgPath

        progressLayer.frame = frame
        progressLayer.path = makeHexagonPath(frame: layer.frame)?.cgPath

        let progressCoverFrame = frame.inset(by: UIEdgeInsets(top: progressLineWith / 2,
                                                              left: progressLineWith / 2,
                                                              bottom: progressLineWith / 2,
                                                              right: progressLineWith / 2))
        progressCoverLayer.frame = progressCoverFrame
        progressCoverLayer.path = makeHexagonPath(frame: progressCoverFrame)?.cgPath

        let iconBGFrame = progressCoverFrame.inset(by: UIEdgeInsets(top: progressImageSpacing,
                                                                    left: progressImageSpacing,
                                                                    bottom: progressImageSpacing,
                                                                    right: progressImageSpacing))
        iconBGLayer.frame = iconBGFrame
        iconBGLayer.path = makeHexagonPath(frame: iconBGFrame)?.cgPath


        let bageLayer = CALayer()
        bageLayer.frame = frame
        bageLayer.addSublayer(progressBGLayer)
        bageLayer.addSublayer(progressLayer)
        bageLayer.addSublayer(progressCoverLayer)
        bageLayer.addSublayer(iconBGLayer)

        let rotationOffset = CGFloat.pi - CGFloat.pi / 6
        let rotation = CGAffineTransform.init(rotationAngle: rotationOffset)
        bageLayer.setAffineTransform(rotation)

        return bageLayer
    }

    func makeHexagonPath(frame: CGRect) -> UIBezierPath? {
        return UIBezierPath(square: frame,
                            lineWidth: progressLineWith,
                            numberOfSides: 6,
                            cornerRadius: cornerRadius)
    }
}

//https://stackoverflow.com/a/34792762/11882615
extension UIBezierPath {

    fileprivate convenience init?(square: CGRect, lineWidth: CGFloat, numberOfSides: UInt, cornerRadius: CGFloat) {

        let squareWidth = min(square.width, square.height)

        guard numberOfSides > 0,
            cornerRadius >= 0.0,
            2.0 * cornerRadius < squareWidth,
            !square.isInfinite,
            !square.isEmpty,
            !square.isNull else {
            return nil
        }

        self.init()

        // how much to turn at every corner
        let theta =  2.0 * .pi / CGFloat(numberOfSides)
        let halfTheta = 0.5 * theta

        // offset from which to start rounding corners
        let offset = cornerRadius * tan(halfTheta)

        var length = squareWidth - lineWidth
        if numberOfSides % 4 > 0 {
            length = length * cos(halfTheta)
        }

        let sideLength = length * tan(halfTheta)

        // start drawing at 'point' in lower left corner
        let p1 = 0.5 * (squareWidth + sideLength) - offset - (sideLength - offset * 2.0)
        let p2 = squareWidth - 0.5 * (squareWidth - length)
        var point = CGPoint(x: p1, y: p2)
        var angle = CGFloat.pi

        move(to: point)

        // draw the sides around rounded corners of the polygon
        for _ in 0..<numberOfSides {
            let centerX = point.x + cornerRadius * cos(angle + 0.5 * .pi)
            let centerY = point.y + cornerRadius * sin(angle + 0.5 * .pi)
            let center = CGPoint(x: centerX, y: centerY)
            let startAngle = angle - 0.5 * .pi
            let endAngle = angle + theta - 0.5 * .pi

            self.addArc(withCenter: center,
                        radius: cornerRadius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: true)

            point = currentPoint
            angle += theta

            let x1 = point.x + ((sideLength - offset * 2.0) * cos(angle))
            let y1 = point.y + ((sideLength - offset * 2.0) * sin(angle))

            point = CGPoint(x: x1, y: y1)
            addLine(to: point)
        }

        self.close()
    }
}
let badgeHeight: CGFloat = 54

let progressBadge = ProgressBadgeView(diameter: badgeHeight)
progressBadge.progressColor = UIColor(red: 0.3, green: 0.63, blue: 0.76, alpha: 1)
progressBadge.progressBackgroundColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.0)
progressBadge.iconBackgroundColor = UIColor(red: 0.3, green: 0.63, blue: 0.76, alpha: 1)
progressBadge.backgroundColor = .white
progressBadge.progress = 0.25

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = progressBadge
