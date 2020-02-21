//
//  Keyframe.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import Foundation
import simd

class Keyframe<T: Lerpable>: Animation {
    
    var startValue: T!
    var endValue: T!
    var target: UnsafeMutablePointer<T>!
    
    var onComplete: ((_ value: T) -> Void)?
    var onUpdate: ((_ progress: Float, _ value: T) -> Void)?
    
    init(target: UnsafeMutablePointer<T>,
         from startValue: T,
         to endValue: T,
         _ duration: Double,
         _ delay: Double,
         _ ease: simd_float4 = Ease.linear,
         _ onComplete: ((_ value: T) -> Void)?,
         _ onUpdate: ((_ progress: Float, _ value: T) -> Void)?) {
        super.init()
        
        self.target = target
        self.startValue = startValue
        self.endValue = endValue
        self.startTime = delay
        self.endTime = self.startTime + duration
        self.ease = ease
        self.onComplete = onComplete
        self.onUpdate = onUpdate
        
        if ease.x == ease.y && ease.z == ease.w {
            self.easeType = .linear
        } else {
            self.easeType = .bezier
        }
    }
    
    override func update(_ progress: Float) {
        active = true
        var percent = progress
        
        if easeType == .bezier {
            percent = Bezier.curveAt(progress, ease.x, ease.y, ease.z, ease.w)
        } else if easeType == .hold {
            percent = progress < 1 ? 0 : 1
        }
        
        let value = startValue.lerp(percent, endValue)
        target.pointee = value
        onUpdate?(percent, value)
    }
    
    override func complete() {
        target.pointee = endValue
        onComplete?(endValue)
        active = false
    }
    
}
