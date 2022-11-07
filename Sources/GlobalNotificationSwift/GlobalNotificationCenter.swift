//
//  GlobalNotificationCenter.swift
//  GlobalNotificationCenter
//
//  Created by Aung Ko Min on 7/11/22.
//

import Foundation

/// A system-wide notification center. This means that all notifications will be delivered to all interested observers, regardless of the process owner. GlobalNotificationCenter don't support userInfo payloads to the notifications. This wrapper is thread-safe.
public final class GlobalNotificationCenter {

    public typealias NotificationHandler = ((GlobalNotification) -> Void)
    public static var shared = GlobalNotificationCenter()
    let center = CFNotificationCenterGetDarwinNotifyCenter()
    private var observations = [Observation]()
    private let queue = DispatchQueue(label: "group.com.jonahaung.GlobalNotificationCenter", qos: .default, attributes: [], autoreleaseFrequency: .workItem)

    private init() {}


    private func cleanupObservers() {
        queue.async {
            self.observations = self.observations.filter { (observation) -> Bool in
                let stillAlive = observation.observer != nil
                if !stillAlive {
                    observation.unobserve()
                }
                return stillAlive
            }
        }
    }

    public func addObserver(_ observer: AnyObject, for name: GlobalNotification.Name, using handler: @escaping NotificationHandler) {
        cleanupObservers()
        queue.async {
            let observation = Observation(observer: observer, name: name, handler: handler)
            if !self.observations.contains(observation) {
                self.observations.append(observation)
            }
        }
    }

    public func removeObserver(_ observer: AnyObject, for name: GlobalNotification.Name? = nil) {
        cleanupObservers()

        queue.async {
            self.observations = self.observations.filter { (observation) -> Bool in
                let shouldRetain = observer !== observation.observer || (name != nil && observation.name != name)
                if !shouldRetain {
                    observation.unobserve()
                }
                return shouldRetain
            }
        }

    }


    public func isObserver(_ observer: AnyObject, for name: GlobalNotification.Name? = nil) -> Bool {
        cleanupObservers()

        return queue.sync(execute: { () -> Bool in
            return observations.contains(where: { (observation) -> Bool in
                return observer === observation.observer && (name == nil || observation.name == name)
            })
        })
    }

    public func postNotification(_ name: GlobalNotification.Name) {
        // Before posting a notification, cleanup all observers that are deallocated.
        cleanupObservers()

        guard let cfNotificationCenter = self.center else {
            fatalError("Invalid CFNotificationCenter")
        }
        CFNotificationCenterPostNotification(cfNotificationCenter, CFNotificationName(rawValue: name.rawValue), nil, nil, false)
    }

    func signalNotification(_ name: GlobalNotification.Name) {
        cleanupObservers()
        queue.async {
            let affectedObservations = self.observations.filter({ (observation) -> Bool in
                return observation.name == name
            })
            let notification = GlobalNotification(name)
            for observation in affectedObservations {
                observation.handler(notification)
            }
        }
    }
}
