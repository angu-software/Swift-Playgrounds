import UIKit

final class CheckBoxListView: UIView {

    enum ViewEvent {
        case selectionStateChanged(CheckBox.SelectionState, itemId: String)
    }

    var viewState: ViewState {
        didSet {
            if oldValue != viewState {
                updateUI()
            }
        }
    }

    var eventAction: ((ViewEvent) -> Void)?

    private let stackView = UIStackView()

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
        addSubview(stackView)
    }

    private func setUpUI() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
    }

    private func layoutUI() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateUI() {
        stackView.arrangedSubviews.forEach { element in
            stackView.removeArrangedSubview(element)
            element.removeFromSuperview()
        }

        viewState.items.forEach { item in
            let checkBoxView = makeCheckBoxView(item: item, itemStyle: viewState.itemStyle)
            checkBoxView.selectionDidChange = { selectionState in
                self.eventAction?(.selectionStateChanged(selectionState, itemId: item.id))
            }
            stackView.addArrangedSubview(checkBoxView)
        }

        stackView.addArrangedSubview(UIView())
    }

    private func makeCheckBoxView(item: ListItem, itemStyle: CheckBox.View.Configuration.CheckBoxStyle) -> CheckBox.View {

        // contained subcomponents are build using their public API
        let configuration = CheckBox.View.Configuration(title: item.title,
                                                        state: item.state,
                                                        style: itemStyle)
        return CheckBox.View(configuration: configuration)
    }
}
