//
//  MathUtils.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

func normalize(value: Double, minimum: Double, maximum: Double) -> Double {
    return (value - minimum) / (maximum - minimum)
}
