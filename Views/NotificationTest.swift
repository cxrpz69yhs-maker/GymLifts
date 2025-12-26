import SwiftUI
import UserNotifications

struct NotificationTestView: View {
    var body: some View {
        Button("Test Notification") {
            let content = UNMutableNotificationContent()
            content.title = "Test Notification"
            content.body = "If you see this, notifications work."
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(
                identifier: "testNotification",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}
