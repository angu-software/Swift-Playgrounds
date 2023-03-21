import UIKit

import PlaygroundSupport

print(playgroundSharedDataDirectory.path)

let snapshotDirectory = playgroundSharedDataDirectory

// take scale into account ✅
// correctly render zPosition of layers ✅
// convenience sizing of views ✅
// simulator independent ✅
// scrollview full content rendering

// comparison and recording of reference images should be thread safe in order to be able to run snapshot tests in parallel

// file management
// * reference images ✅
// * failure diffs ✅
// configure
// * file naming
// * folder paths (folder per test class)
// <basePath>/ReferenceSnapshots/<test_class>/<test_method_name>@<scale>x.png ✅
// <basePath>/FailureDiffs/<test_class>/<test_method_name>@<scale>x_<[diff|fail|ref]>.png

// switch on record mode
// * globally for all tests
// * per test class
// * per test method

// (quick) Survey to gather current pain points and nice to haves from devs
// Is knowing who much pixels differ important?

// Are trait collections a thing?

// MARK: - Playground

let configuration = Configuration(snapshotImageScale: 2)
let imageRenderer = SnapshotRenderer(scale: configuration.snapshotImageScale)

let referenceImage = Snapshot(named: "image1")!
let testImage = Snapshot(named: "image2")!

let imageDiff = imageRenderer.differenceSnapshot(of: referenceImage, comparedTo: testImage)

let refLabel = UILabel()
refLabel.text = "Hello World"
refLabel.backgroundColor = .white
refLabel.frame.size = refLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

let testLabel = UILabel()
testLabel.text = "Hello W0rld 1234"
testLabel.backgroundColor = .white
testLabel.layer.zPosition = 1000
testLabel.frame.size = testLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

let refLabelImage = imageRenderer.snapshot(of: refLabel)
let testLabelImage = imageRenderer.snapshot(of: testLabel)
let viewDiff = imageRenderer.differenceSnapshot(of: refLabelImage, comparedTo: testLabelImage)

// layer z-index rendering

let view1 = UIView()
view1.backgroundColor = .red
view1.layer.zPosition = 0

let view2 = UIView()
view2.backgroundColor = .blue
view2.layer.zPosition = 1

let container = UIView()
container.backgroundColor = .white

container.addSubview(view2)
container.addSubview(view1)

view1.translatesAutoresizingMaskIntoConstraints = false
view2.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view1.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//    view1.centerYAnchor.constraint(equalTo: container.centerYAnchor),
    view1.widthAnchor.constraint(equalToConstant: 100),
    view1.heightAnchor.constraint(equalToConstant: 100),
    view2.centerXAnchor.constraint(equalTo: view1.centerXAnchor, constant: 35),
    view2.centerYAnchor.constraint(equalTo: view1.centerYAnchor),
    view2.widthAnchor.constraint(equalToConstant: 50),
    view2.heightAnchor.constraint(equalToConstant: 50),

    view1.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
    view1.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
])

let containerSizingSize = container.size(for: Sizing(width: .fixed(value: 200), height: .compressed))
let containerFittingSize = container.systemLayoutSizeFitting(CGSize(width: 100, height: 0),
                                                             withHorizontalFittingPriority: .required,
                                                             verticalFittingPriority: .fittingSizeLevel)

container.frame.size = containerSizingSize
let image1 = imageRenderer.snapshot(of: container)

view2.layer.zPosition = 0
let image2 = imageRenderer.snapshot(of: container)

let diffImage = imageRenderer.differenceSnapshot(of: image1, comparedTo: image2)

image1 == image1
image2 == image2
image1 == image2

let sameDiffImage = imageRenderer.differenceSnapshot(of: image1, comparedTo: image1)

UIView.layoutFittingCompressedSize
UIView.layoutFittingExpandedSize
let compressedSize = container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
let expandedSize = container.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
