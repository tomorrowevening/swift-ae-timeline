# swift-ae-timeline
After Effects to Swift

Keyframes can animate all "Lerpable" items, so currently:
 - Double
 - Float
 - Float2
 - Float3
 - Float4
 - Quatf

Let's take a look to see how this can be used:
```
/// Timeline
let animation = Timeline()
animation.mode = .once
animation.duration = 3
// make sure to call animation.update() every frame

/// Markers
animation.addMarker("inComplete", 1, "stop", nil)
animation.addMarker("outComplete", 3, "stop", {
	print("Dismiss item")
})

/// Keyframes
// Fade in

animation.addKeyframe(
	target: UnsafeMutablePointer<Float>(&self.material.opacity),
	from: 0,
	to: 1,
	0.5, 0, Ease.linear
)

// Fade out
animation.addKeyframe(
	target: UnsafeMutablePointer<Float>(&self.material.opacity),
	from: 1,
	to: 0,
	0.5, 2.5, Ease.linear
)

// Move position in
animation.addKeyframe(
	target: UnsafeMutablePointer<simd_float3>(&self.position),
	from: simd_make_float3(0, 0, 1000),
	to: simd_make_float3(0, 0, 0),
	1, 0, Ease.outQuart, { (_ progress: Float, _ value: simd_float3) in
		print("Let's also track the position:", progress, value)
	}
)

// Move position out
animation.addKeyframe(
	target: UnsafeMutablePointer<simd_float3>(&self.position),
	from: simd_make_float3(0, 0, 0),
	to: simd_make_float3(0, 0, 1000),
	1, 2, Ease.outQuart
)
```