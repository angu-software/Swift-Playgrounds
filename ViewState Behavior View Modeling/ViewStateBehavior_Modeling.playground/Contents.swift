//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

final class MyViewController : UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .black

        let items: [CheckBox.ListView.ListItem] = [.init(title: "Number one"),
                                                   .init(title: "Number two")]
        let checkBoxListView = CheckBox.ListView(items: items,
                                                 itemStyle: .seal)
        checkBoxListView.listItemDidChange = {
            print("listItemDidChange: \($0)")
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubview(checkBoxListView)

        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        self.view.frame = CGRect(origin: .zero,
                                 size: CGSize(width: 200,
                                              height: 500))
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
