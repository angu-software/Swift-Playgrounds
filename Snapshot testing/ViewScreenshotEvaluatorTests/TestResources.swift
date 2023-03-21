//
//  TestResources.swift
//  ViewScreenshotEvaluatorTests
//
//  Created by Andreas Guenther on 07.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

import Foundation

struct Tests {

    static var resourcesURL: URL {
        var url = URL(fileURLWithPath: #file)
        url.deleteLastPathComponent()
        url.appendPathComponent("Resources")
        return url
    }
}
