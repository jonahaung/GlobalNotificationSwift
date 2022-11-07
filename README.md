# GlobalNotificationSwift

A description of this package.

A system-wide notification center. This means that all notifications will be delivered to all interested observers, regardless of the process owner. GlobalNotificationCenter don't support userInfo payloads to the notifications. This wrapper is thread-safe.

** How to Install **

Install SwiftPackage at https://github.com/jonahaung/GlobalNotificationSwift

** Sample Code **

//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.text)
                    .font(.title)
                Spacer()

                Button("Trigger Global Notification") {
                    viewModel.triggerExternalNotification()
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            .padding()
        }
    }
}


final class ViewModel: ObservableObject {
    @Published var text = ""
    private let identifier = "ContentViewModel"
    init() {
        observeExternalNotification()
    }
    private func observeExternalNotification() {
        GlobalNotificationCenter.shared.addObserver(self, for: .customExternalAppDidFireNotification(customId: identifier), using: customExternalNotificationHandler(_:))
    }

    private func customExternalNotificationHandler(_ globalNotification: GlobalNotification) {
        DispatchQueue.main.async {
            self.text = """
    Custom Exteral Notification
    \(globalNotification.name.rawValue as String)
    \(Date.now.formatted(date: .abbreviated, time: .complete))
    """
        }
    }
    func triggerExternalNotification() {
        GlobalNotificationCenter.shared.postNotification(.customExternalAppDidFireNotification(customId: identifier))
    }
}


//
