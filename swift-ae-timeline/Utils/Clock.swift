//
//  Clock.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import Foundation

class Clock {
    
    var startTime: Double
    var elapsedTime: Double
    var deltaTime: Double
    
    init() {
        self.startTime = 0.0
        self.elapsedTime = 0.0
        self.deltaTime = 0.0
    }
    
    func reset() {
        startTime = Date.getNow()
        elapsedTime = 0
        deltaTime = 0
    }
    
    func update() {
        let prevTime = elapsedTime
        elapsedTime = (Date.getNow() - startTime) / 1000.0
        deltaTime = elapsedTime - prevTime
    }
    
}
