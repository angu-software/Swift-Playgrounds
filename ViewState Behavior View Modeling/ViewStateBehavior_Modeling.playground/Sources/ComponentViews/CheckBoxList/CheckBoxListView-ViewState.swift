import Foundation

extension CheckBoxListView {

    typealias ListItem = CheckBox.ListView.ListItem
    typealias CheckBoxStyle = CheckBox.View.Configuration.CheckBoxStyle

    struct ViewState: Equatable {
        let items: [ListItem]
        let itemStyle: CheckBoxStyle
    }
}
