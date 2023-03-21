import UIKit

extension CheckBox {

    public final class ListView: UIView {

        public struct Configuration {

            public typealias CheckBoxStyle = CheckBox.View.Configuration.CheckBoxStyle

            public let items: [ListItem]
            public let itemStyle: CheckBoxStyle

            init(items: [ListItem],
                 itemStyle: CheckBoxStyle = .square) {
                self.items = items
                self.itemStyle = itemStyle
            }
        }

        public struct ListItem: Equatable {
            public let id: String
            public let title: String
            public internal(set) var state: CheckBox.SelectionState

            public init(id: String = UUID().uuidString,
                        title: String,
                        state: CheckBox.SelectionState = .deselected) {
                self.id = id
                self.title = title
                self.state = state
            }
        }

        public var items: [ListItem] {
            return checkBoxListView.viewState.items
        }

        public var listItemDidChange: ((ListItem) -> Void)?

        private let checkBoxListView: CheckBoxListView
        private let behavior: Behavior

        private var viewState: CheckBoxListView.ViewState {
            get {
                return checkBoxListView.viewState
            }
            set {
                checkBoxListView.viewState = newValue
            }
        }

        // This init is more convenient for the two parameters on consumer side.
        //
        // If in the future the Configuration contains more parameters to be adjustable this init could still stay for more common use cases to use.
        public convenience init(items: [ListItem], itemStyle: Configuration.CheckBoxStyle = .square) {
            self.init(configuration: Configuration(items: items, itemStyle: itemStyle))
        }

        public init(configuration: Configuration) {
            let viewState = CheckBoxListView.ViewState(items: configuration.items,
                                                       itemStyle: configuration.itemStyle)
            self.checkBoxListView = CheckBoxListView(viewState: viewState)
            self.behavior = Behavior()

            super.init(frame: .zero)

            initUI()
            setUpUI()
            layoutUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func initUI() {
            addSubview(checkBoxListView)
        }

        private func setUpUI() {
            checkBoxListView.eventAction = { event in
                switch event {
                case let .selectionStateChanged(selectionState, itemId):
                    guard let update = self.behavior.updatedViewState(self.viewState,
                                                                bySetting: selectionState,
                                                                      forFirstItemWithId: itemId) else {
                        return
                    }

                    self.viewState = update.viewState
                    self.listItemDidChange?(update.changedItem)
                }
            }
        }

        private func layoutUI() {
            checkBoxListView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                checkBoxListView.topAnchor.constraint(equalTo: topAnchor),
                checkBoxListView.leadingAnchor.constraint(equalTo: leadingAnchor),
                checkBoxListView.trailingAnchor.constraint(equalTo: trailingAnchor),
                checkBoxListView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}

extension CheckBox.ListView {

    struct Behavior {

        typealias ViewState = CheckBoxListView.ViewState

        func updatedViewState(_ viewState: ViewState, bySetting selectionState: CheckBox.SelectionState, forFirstItemWithId itemId: String) -> (viewState: ViewState, changedItem: ListItem)? {

            var items = viewState.items
            for (index, var item) in items.enumerated() where item.id == itemId {
                item.state = selectionState
                items[index] = item

                return (ViewState(items: items,
                                  itemStyle: viewState.itemStyle),
                        item)
            }

            return nil
        }
    }
}
