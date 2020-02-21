//
//  Date+Extension.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    static func getNow() -> Double {
        return Double(Date().currentTimeMillis())
    }
}
