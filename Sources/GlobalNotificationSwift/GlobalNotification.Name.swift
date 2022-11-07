//
//  GlobalNotification.Name.swift
//  GlobalNotificationCenter
//
//  Created by Aung Ko Min on 7/11/22.
//

import Foundation

extension GlobalNotification.Name {
    public init(_ rawValue: String) {
        self.rawValue = rawValue as CFString
    }
    init(_ cfNotificationName: CFNotificationName) {
        rawValue = cfNotificationName.rawValue
    }
    public static func == (lhs: GlobalNotification.Name, rhs: GlobalNotification.Name) -> Bool {
        return (lhs.rawValue as String) == (rhs.rawValue as String)
    }
}

extension GlobalNotification.Name {
    private static let appIsExtension = Bundle.main.bundlePath.hasSuffix(".appex")

    static var externalAppDidFireNotification: GlobalNotification.Name {
        if appIsExtension {
            return localAppDidFire
        } else {
            return extensionAppDidFire
        }
    }
    static var localAppDidFireNotification: GlobalNotification.Name {
        if appIsExtension {
            return extensionAppDidFire
        } else {
            return localAppDidFire
        }
    }
    private static var extensionAppDidFire: GlobalNotification.Name {
        return GlobalNotification.Name("com.jonahaung.GlobalNotificationCenter")
    }
    private static var localAppDidFire: GlobalNotification.Name {
        return GlobalNotification.Name("com.jonahaung.GlobalNotificationCenter")
    }


    static func customExternalAppDidFireNotification(customId: String) -> GlobalNotification.Name {
        if appIsExtension {
            return customLocalAppDidFire(customId: customId)
        } else {
            return customExtensionAppDidFire(customId: customId)
        }
    }
    static func customLocalAppDidFireNotification(customId: String) -> GlobalNotification.Name {
        if appIsExtension {
            return customExtensionAppDidFire(customId: customId)
        } else {
            return customLocalAppDidFire(customId: customId)
        }
    }
    private static func customExtensionAppDidFire(customId: String) -> GlobalNotification.Name {
        return GlobalNotification.Name("com.jonahaung.GlobalNotificationCenter.\(customId)")
    }
    private static func customLocalAppDidFire(customId: String) -> GlobalNotification.Name {
        return GlobalNotification.Name("com.jonahaung.GlobalNotificationCenter.\(customId)")
    }
}
