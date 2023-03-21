//
//  Screenshot.swift
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 04.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import UIKit

struct Screenshot: Equatable {

    let pngData: Data

    var image: UIImage? {
        return UIImage(data: pngData)
    }

    init(pngData: Data) {
        self.pngData = pngData
    }

    init?(contentsOf url: URL) {

        guard let pngData = try? Data(contentsOf: url) else {
            return nil
        }
        self.pngData = pngData
    }
}
