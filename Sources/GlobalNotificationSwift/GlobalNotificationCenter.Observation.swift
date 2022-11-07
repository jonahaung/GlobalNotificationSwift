//
//  GlobalNotificationCenter.Observation.swift
//  GlobalNotificationCenter
//
//  Created by Aung Ko Min on 7/11/22.
//

import Foundation

public extension GlobalNotificationCenter {

    final class Observation {
        let handler: GlobalNotificationCenter.NotificationHandler
        let name: GlobalNotification.Name

        weak var observer: AnyObject?

        init(observer: AnyObject, name: GlobalNotification.Name, handler: @escaping GlobalNotificationCenter.NotificationHandler) {
            self.observer = observer
            self.name = name
            self.handler = handler
            observe()
        }
    }
}

extension GlobalNotificationCenter.Observation: Equatable {

    public func observe() {
        guard let cfCenter = GlobalNotificationCenter.shared.center else {
            fatalError("Invalid GlobalNotificationCenter observation info.")
        }

        // A notification callback. Since this is a C function pointer, it can not have any ownership context.
        let callback: CFNotificationCallback = { (center, observer, name, object, userInfo) in
            guard let cfName = name else {
                return
            }

            let notificationName = GlobalNotification.Name(cfName)
            GlobalNotificationCenter.shared.signalNotification(notificationName)
        }
        let observer = Unmanaged.passUnretained(self).toOpaque()
        CFNotificationCenterAddObserver(cfCenter, observer, callback, name.rawValue, nil, .coalesce)
    }

    /// Stop observing the notification. This should be done whenever the observation is going to be removed.
    public func unobserve() {
        guard let cfCenter = GlobalNotificationCenter.shared.center else {
            fatalError("Invalid GlobalNotificationCenter observation info.")
        }
        let notificationName = CFNotificationName(rawValue: name.rawValue)
        var observer = self
        CFNotificationCenterRemoveObserver(cfCenter, &observer, notificationName, nil)
    }

    public static func == (lhs: GlobalNotificationCenter.Observation, rhs: GlobalNotificationCenter.Observation) -> Bool {
        return lhs.observer === rhs.observer && lhs.name == rhs.name
    }
}
