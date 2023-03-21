import Foundation

extension CheckBoxView {
    
    struct ViewState: Equatable {
        let selectionState: CheckBox.SelectionState
        let title: String
        let style: ViewStyle
    }

    struct ViewStyle: Equatable {

        typealias CheckBoxStyle = CheckBox.View.Configuration.CheckBoxStyle

        static let checkbox = Self(deselectedIconName: "square",
                                   selectedIconName: "checkmark.square")
        static let seal = Self(deselectedIconName: "seal",
                               selectedIconName: "checkmark.seal")

        let deselectedIconName: String
        let selectedIconName: String

        init(checkBoxStyle: CheckBoxStyle) {
            switch checkBoxStyle {
            case .square:
                self = .checkbox
            case .seal:
                self = .seal
            }
        }

        private init(deselectedIconName: String,
                     selectedIconName: String) {
            self.deselectedIconName = deselectedIconName
            self.selectedIconName = selectedIconName
        }
    }
}
