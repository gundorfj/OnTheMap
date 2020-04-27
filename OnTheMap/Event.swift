//
//  Event.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 23/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import Foundation

class Event<T> {
    
    typealias EventHandler = (T) -> ()

    private var eventHandlers = [EventHandler]()

    func addHandler(handler: @escaping EventHandler) {
        eventHandlers.append(handler)
        }

    func raise(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
