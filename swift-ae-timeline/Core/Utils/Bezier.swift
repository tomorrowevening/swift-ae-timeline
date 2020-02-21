//
//  Bezier.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import simd

/**
 * CSS based
 */
public struct Ease {
    
    static let linear = simd_make_float4(0.250, 0.250, 0.750, 0.750)
    
    /// In
    static let inQuad = simd_make_float4(0.550, 0.085, 0.680, 0.530)
    static let inCubic = simd_make_float4(0.550, 0.055, 0.675, 0.190)
    static let inQuart = simd_make_float4(0.895, 0.030, 0.685, 0.220)
    static let inQuint = simd_make_float4(0.755, 0.050, 0.855, 0.060)
    static let inSine = simd_make_float4(0.470, 0.000, 0.745, 0.715)
    static let inExpo = simd_make_float4(0.950, 0.050, 0.795, 0.035)
    static let inCirc = simd_make_float4(0.600, 0.040, 0.980, 0.335)
    static let inBack = simd_make_float4(0.600, 0.000, 0.735, 0.045)
    
    /// Out
    static let outQuad = simd_make_float4(0.250, 0.460, 0.450, 0.940)
    static let outCubic = simd_make_float4(0.215, 0.610, 0.355, 1.000)
    static let outQuart = simd_make_float4(0.165, 0.840, 0.440, 1.000)
    static let outQuint = simd_make_float4(0.230, 1.000, 0.320, 1.000)
    static let outSine = simd_make_float4(0.390, 0.575, 0.565, 1.000)
    static let outExpo = simd_make_float4(0.190, 1.000, 0.220, 1.000)
    static let outCirc = simd_make_float4(0.075, 0.820, 0.165, 1.000)
    static let outBack = simd_make_float4(0.175, 0.885, 0.320, 1.000)
    
    /// In Out
    static let inOutQuad = simd_make_float4(0.455, 0.030, 0.515, 0.955)
    static let inOutCubic = simd_make_float4(0.645, 0.045, 0.355, 1.000)
    static let inOutQuart = simd_make_float4(0.770, 0.000, 0.175, 1.000)
    static let inOutQuint = simd_make_float4(0.860, 0.000, 0.070, 1.000)
    static let inOutSine = simd_make_float4(0.445, 0.050, 0.550, 0.950)
    static let inOutExpo = simd_make_float4(1.000, 0.000, 0.000, 1.000)
    static let inOutCirc = simd_make_float4(0.785, 0.135, 0.150, 0.860)
    static let inOutBack = simd_make_float4(0.680, 0.000, 0.265, 1.000)
    
}

public struct Bezier {
    
    static func isLinear(_ x0: Float, _ y0: Float, _ x1: Float, _ y1: Float) -> Bool {
        return x0 == y0 && x1 == y1
    }

    static func curveAt(_ percent: Float, _ x0: Float, _ y0: Float, _ x1: Float, _ y1: Float) -> Float {
        if percent <= 0 { return 0 }
        
        if percent >= 1 { return 1 }
        
        if isLinear(x0, y0, x1, y1) { return percent }

        let x0a: Float = 0.0 // initial x
        let y0a: Float = 0.0 // initial y
        let x1a: Float = x0 // 1st influence x
        let y1a: Float = y0 // 1st influence y
        let x2a: Float = x1 // 2nd influence x
        let y2a: Float = y1 // 2nd influence y
        let x3a: Float = 1.0 // final x
        let y3a: Float = 1.0 // final y
        let a0: Float = x3a - 3.0 * x2a + 3.0 * x1a - x0a
        let b0: Float = 3.0 * x2a - 6.0 * x1a + 3.0 * x0a
        let c0: Float = 3.0 * x1a - 3.0 * x0a
        let d0: Float = x0a

        let e0: Float = y3a - 3.0 * y2a + 3.0 * y1a - y0a
        let f0: Float = 3.0 * y2a - 6.0 * y1a + 3.0 * y0a
        let g0: Float = 3.0 * y1a - 3.0 * y0a
        let h0: Float = y0a

        var current = percent
        for _ in 0...4 {
            let currentx = xFromT(current, a0, b0, c0, d0)
            var currentslope = slopeFromT(current, a0, b0, c0)
            if currentslope == Float.infinity {
                currentslope = percent
            }
            current -= (currentx - percent) * (currentslope)
            current = min(max(current, 0.0), 1.0)
        }

        return yFromT(current, e0, f0, g0, h0)
    }

    static func slopeFromT(_ value: Float, _ x0: Float, _ x1: Float, _ x2: Float) -> Float {
        return 1.0 / (3.0 * x0 * value * value + 2.0 * x1 * value + x2)
    }

    static func xFromT(_ value: Float, _ x0: Float, _ x1: Float, _ x2: Float, _ x3: Float) -> Float {
        return x0 * (value * value * value) + x1 * (value * value) + x2 * value + x3
    }

    static func yFromT(_ value: Float, _ x0: Float, _ x1: Float, _ x2: Float, _ x3: Float) -> Float {
        let value2 = value * value
        return x0 * (value2 * value) + x1 * value2 + x2 * value + x3
    }
    
}
