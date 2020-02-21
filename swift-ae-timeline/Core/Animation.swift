//
//  Animation.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import Foundation
import simd

enum AnimationType {
    case linear
    case bezier
    case hold
}

// MARK: - Animation

public class Animation {
    
    var active: Bool
    var startTime: Double
    var endTime: Double
    var ease: simd_float4
    var easeType: AnimationType
    
    init() {
        self.active = false
        self.startTime = 0
        self.endTime = 0
        self.ease = Ease.linear
        self.easeType = .linear
    }
    
    func update(_ progress: Float) {
        ///
    }
    
    func restart() {
        update(0)
    }
    
    func complete() {
        active = false
    }
    
    func isActive(_ time: Double) -> Bool {
        return time >= startTime && time <= endTime
    }
    
}
