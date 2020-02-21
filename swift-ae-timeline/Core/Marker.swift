//
//  Marker.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import Foundation

struct Marker {
    var name: String = ""
    var time: Double = 0
    var action: String = ""
    var trigger: (() -> Void)?
}
