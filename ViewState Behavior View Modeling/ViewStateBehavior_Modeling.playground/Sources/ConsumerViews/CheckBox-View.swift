import UIKit

extension CheckBox {

    public final class View: UIView {

        public struct Configuration {

            public enum CheckBoxStyle: Equatable {
                case square
                case seal
            }

            public let title: String
            public let state: SelectionState
            public let style: CheckBoxStyle

            public init(title: String,
                        state: SelectionState = .deselected,
                        style: CheckBoxStyle = .square) {
                self.state = state
                self.title = title
                self.style = style
            }
        }

        public var selectionState: SelectionState {
            return viewState.selectionState
        }

        public var selectionDidChange: ((SelectionState) -> Void)?

        private let behavior: CheckBoxView.Behavior
        private let checkBoxView: CheckBoxView

        private var viewState: CheckBoxView.ViewState {
            get {
                checkBoxView.viewState
            }

            set {
                if newValue != checkBoxView.viewState {
                    checkBoxView.viewState = newValue
                    selectionDidChange?(newValue.selectionState)
                }
            }
        }

        public init(configuration: Configuration) {
            self.behavior = CheckBoxView.Behavior(configuration: configuration)
            self.checkBoxView = CheckBoxView(viewState: behavior.makeInitialViewState())

            super.init(frame: .zero)

            addSubview(checkBoxView)

            checkBoxView.didTap = {
                self.onTap()
            }

            checkBoxView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                checkBoxView.topAnchor.constraint(equalTo: topAnchor),
                checkBoxView.leadingAnchor.constraint(equalTo: leadingAnchor),
                checkBoxView.trailingAnchor.constraint(equalTo: trailingAnchor),
                checkBoxView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func onTap() {
            self.viewState = behavior.makeViewStateForCheckboxTapped(currentViewState: viewState)
        }
    }
}

extension CheckBoxView {

    struct Behavior {

        typealias ViewState = CheckBoxView.ViewState
        typealias ViewStyle = CheckBoxView.ViewStyle
        typealias Configuration = CheckBox.View.Configuration
        typealias CheckBoxStyle = CheckBox.View.Configuration.CheckBoxStyle

        private let configuration: Configuration

        init(configuration: Configuration) {
            self.configuration = configuration
        }

        func makeInitialViewState() -> ViewState {
            return ViewState(selectionState: configuration.state,
                             title: configuration.title,
                             style: ViewStyle(checkBoxStyle: configuration.style))
        }

        func makeViewStateForCheckboxTapped(currentViewState: ViewState) -> ViewState {
            return ViewState(selectionState: currentViewState.selectionState.toggled(),
                             title: currentViewState.title,
                             style: ViewStyle(checkBoxStyle: configuration.style))
        }
    }
}

extension CheckBox.SelectionState {

    fileprivate func toggled() -> Self {
        switch self {
        case .selected:
            return .deselected
        case .deselected:
            return .selected
        }
    }
}
