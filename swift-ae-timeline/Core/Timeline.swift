//
//  Timeline.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import Foundation
import simd

enum PlayMode {
    case loop
    case once
    case pingPong
}

protocol Timelineable {
    func setupTimeline(_ timeline: Timeline)
}

// MARK: - Timeline

class Timeline: Event<(String, String)> {
    
    var seconds: Double
    var duration: Double
    var speed: Double
    var mode: PlayMode
    var playing: Bool
    
    var keyframes: [Animation]
    var markers: [Marker]
    
    private var lastTime: Double
    
    override init() {
        self.seconds = 0
        self.duration = 0
        self.speed = 1
        self.mode = .loop
        self.playing = true
        self.lastTime = -1
        
        self.keyframes = []
        self.markers = []
        
        super.init()
    }
    
    // MARK: - Playback
    
    func play() {
        playing = true
    }
    
    func pause() {
        playing = false
    }
    
    func update(_ deltaTime: Double) {
        if !playing {
            return
        }
        
        updateKeyframes()
        
        // Enable time remapping
        let localTime = seconds + (deltaTime * speed)
        updateTime(localTime)
        
        updateMarkers()
    }
    
    private func updateTime(_ time: Double) {
        lastTime = seconds
        seconds = time
        
        if seconds >= duration {
            if mode == .loop {
                seconds = 0
                
                // Restart Keyframes
                for keyframe in keyframes.reversed() {
                    keyframe.restart()
                }
            } else if mode == .once {
                seconds = duration
                pause()
            } else {
                // Ping Pong
                seconds = duration - (1.0 / 60.0)
                speed *= -1.0
            }
        }
        
        if seconds < 0 {
            if mode == .pingPong {
                seconds = 0
                speed = abs(speed)
            } else if mode == .once {
                seconds = 0
                playing = false
            } else { /// loop
                seconds += duration
            }
        }
    }
    
    private func updateKeyframes() {
        keyframes.sort(by: { $0.startTime < $1.startTime })
        
        var index = 0
        for keyframe in keyframes {
            if keyframe.isActive(seconds) {
                var percent = normalize(value: seconds, minimum: keyframe.startTime, maximum: keyframe.endTime)
                percent = simd_clamp(percent, 0.0, 1.0)
                keyframe.update(Float(percent))
            } else if keyframe.active {
                keyframe.complete()
            }
            index += 1
        }
    }
    
    private func updateMarkers() {
        for marker in markers {
            var triggered = false
            
            if speed > 0 {
                triggered = marker.time >= lastTime && marker.time <= seconds
            } else if speed < 0 {
                triggered = marker.time >= seconds && marker.time <= lastTime
            }
            
            if triggered {
                if marker.action == "stop" {
                    pause()
                    seconds = marker.time
                }
                
                marker.trigger?()
                dispatch(data: ("marker", marker.name))
            }
        }
    }
    
    func gotoMarker(_ name: String) {
        for marker in markers where marker.name == name {
            seconds = marker.time
            lastTime = -1
        }
    }
    
    // MARK: - Management
    
    /**
     Adds a keyframe to the animation
     - Parameter startValue: The start value
     - Parameter endValue: The end value
     - Parameter duration: The duration of the animation
     - Parameter delay: How long to delay the animation
     - Parameter onComplete: An optional  callback when the animation is complete
     - Parameter onUpdate: An optional  callback when the animation updates every frame
     */
    func addKeyframe<T: Lerpable>(target: UnsafeMutablePointer<T>,
                                  from startValue: T,
                                  to endValue: T,
                                  _ duration: Double,
                                  _ delay: Double,
                                  _ ease: simd_float4 = Ease.linear,
                                  _ onUpdate: ((_ progress: Float, _ value: T) -> Void)? = nil,
                                  _ onComplete: ((_ value: T) -> Void)? = nil) {
        keyframes.append(
            Keyframe(
                target: target,
                from: startValue,
                to: endValue,
                duration,
                delay,
                ease,
                onComplete,
                onUpdate
            )
        )
    }
    
    /**
     Adds a marker to the timeline for playback purposes
     - Parameter name: The name you identify the Marker as
     - Parameter time: The time the Marker gets triggered
     - Parameter action: The name of the action that should take place (optional)
     - Parameter trigger: Callback function for when the Marker gets called (optional)
     */
    func addMarker(_ name: String, _ time: Double, _ action: String, _ trigger: (() -> Void)?) {
        markers.append(
            Marker(
                name: name,
                time: time,
                action: action,
                trigger: trigger
            )
        )
    }
    
}
