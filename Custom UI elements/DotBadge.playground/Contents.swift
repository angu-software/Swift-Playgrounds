//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

final class DotBadge: UIView {

    var badgeColor: UIColor? {
        get {
            return backgroundColor
        }
        set {
            backgroundColor = newValue
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: badgeSize + boardWidth, height: badgeSize + boardWidth)
    }

    private let badgeSize: CGFloat = 24
    private let boardWidth: CGFloat = 1.0
    private let defaultColor = UIColor.green

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)

        setupUI()
        styleUI()
    }

    // MARK: - Private

    private func setupUI() {
        layer.cornerRadius = (badgeSize + boardWidth) * 0.5
        layer.borderWidth = boardWidth
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = true
    }

    private func styleUI() {
        badgeColor = defaultColor
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .black

        let label = DotBadge()
        label.frame.size = label.intrinsicContentSize

        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
