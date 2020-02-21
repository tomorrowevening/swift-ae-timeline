//
//  Event.swift
//  swift-ae-timeline
//
//  Created by Colin Duffy on 12/28/19.
//  Copyright © 2019 Colin Duffy. All rights reserved.
//

/**
 * Based on: https://blog.scottlogic.com/2015/02/05/swift-events.html
 */
class Event<T> {

    typealias EventHandler = (T) -> Void

    private var eventHandlers = [EventHandler]()

    func listen(handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }

    func dispatch(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
