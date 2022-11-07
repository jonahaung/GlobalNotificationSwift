//
//  GlobalNotification.swift
//  GlobalNotificationCenter
//
//  Created by Aung Ko Min on 7/11/22.
//

import Foundation
public struct GlobalNotification {
    public struct Name: Equatable {
        var rawValue: CFString
    }
    public var name: Name
    public init(_ name: Name) {
        self.name = name
    }
}
