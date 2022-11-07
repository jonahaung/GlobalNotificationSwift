# GlobalNotificationSwift

A description of this package.

A system-wide notification center. This means that all notifications will be delivered to all interested observers, regardless of the process owner. GlobalNotificationCenter don't support userInfo payloads to the notifications. This wrapper is thread-safe.

How to Installl

Install SwiftPackage at https://github.com/jonahaung/GlobalNotificationSwift

// Sample Code

// Posting 

            GlobalNotificationCenter.shared.postNotification(.customExternalAppDidFireNotification(customId: identifier))
    
// Receiving

 func customExternalNotificationHandler(_ globalNotification: GlobalNotification) {
        // Do Something Here
}

