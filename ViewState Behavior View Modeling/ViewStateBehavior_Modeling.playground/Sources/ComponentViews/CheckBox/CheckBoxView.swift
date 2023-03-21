import UIKit

// Use SFSymbols

final class CheckBoxView: UIView {

    var viewState: ViewState {
        didSet {
            if oldValue != viewState {
                updateUI()
            }
        }
    }

    var didTap: (() -> Void)?

    private let button = UIButton(frame: .zero)

    init(viewState: ViewState) {
        self.viewState = viewState

        super.init(frame: .zero)

        initUI()
        setUpUI()
        layoutUI()
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initUI() {
        addSubview(button)
    }

    private func setUpUI() {
        button.setImage(UIImage(systemName: viewState.style.deselectedIconName), for: .normal)
        button.setImage(UIImage(systemName: viewState.style.selectedIconName), for: .selected)
        button.setTitle(viewState.title, for: .normal)

        button.addTarget(self, action: #selector(didTapCheckBox), for: .touchUpInside)
    }

    private func layoutUI() {
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateUI() {
        button.isSelected = viewState.selectionState == .selected ? true : false
    }

    @objc
    private func didTapCheckBox() {
        didTap?()
    }
}
