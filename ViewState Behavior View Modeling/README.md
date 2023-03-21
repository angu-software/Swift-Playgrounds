# ViewState Behavior View Modeling

THis approach aims for separation of View implementation and its behavioral logic.
The goal to be able to implement the View regardles of the used UI framework and potentially replacing it with another. The defined behavioral loginc of the View to implement is separate and can be used as is when replacing the UI framework.

It can help to transition for UIKit View implementaions to SwiftUI.