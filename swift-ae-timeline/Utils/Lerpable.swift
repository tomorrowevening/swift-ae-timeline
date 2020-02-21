//
//  Lerpable.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import simd

// MARK: - Lerpable

public protocol Lerpable {
    
    /**
     - Parameter progress: The time between the current value (self) and the end value (end)
     - Parameter end: The end value
     - Returns: Interpolated value between self and end
     */
    func lerp(_ progress: Float, _ end: Self) -> Self
}

/// Floats

extension Float: Lerpable {
    public func lerp(_ progress: Float, _ end: Float) -> Float {
        return self + (end - self) * progress
    }
}

extension simd_float2: Lerpable {
    public func lerp(_ progress: Float, _ end: simd_float2) -> simd_float2 {
        return self + (end - self) * progress
    }
}

extension simd_float3: Lerpable {
    public func lerp(_ progress: Float, _ end: simd_float3) -> simd_float3 {
        return self + (end - self) * progress
    }
}

extension simd_float4: Lerpable {
    public func lerp(_ progress: Float, _ end: simd_float4) -> simd_float4 {
        return self + (end - self) * progress
    }
}
 
/// Doubles

extension Double: Lerpable {
    public func lerp(_ progress: Float, _ end: Double) -> Double {
        return self + (end - self) * Double(progress)
    }
}

/// Quaternion

extension simd_quatf: Lerpable {
    public func lerp(_ progress: Float, _ end: simd_quatf) -> simd_quatf {
        return simd_slerp(self, end, progress)
    }
}
