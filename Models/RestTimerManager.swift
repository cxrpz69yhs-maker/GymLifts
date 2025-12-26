import Foundation
import Combine
import UIKit
import UserNotifications

class RestTimerManager: ObservableObject {
    @Published var shouldNotifyOnFinish: Bool = false
    @Published var remainingSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var totalSeconds: Int = 0
    @Published var targetEndTime: Date?

    private var timer: AnyCancellable?

    // MARK: - Start Timer
    func start() {
        // Only set totalSeconds if it's zero (fresh start)
        if totalSeconds == 0 {
            totalSeconds = remainingSeconds
        }

        // Store when the timer will finish
        targetEndTime = Date().addingTimeInterval(TimeInterval(remainingSeconds))

        isRunning = true

        timer?.cancel()

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.pause()
                }
            }
    }

    // MARK: - Pause Timer
    func pause() {
        isRunning = false
        timer?.cancel()
        timer = nil
        cancelPendingNotification()
    }

    // MARK: - Reset Timer
    func reset() {
        pause()
        remainingSeconds = 0
        totalSeconds = 0
        targetEndTime = nil
    }

    // MARK: - Add Time
    func add(seconds: Int) {
        remainingSeconds += seconds

        if totalSeconds == 0 {
            totalSeconds = remainingSeconds
        }

        if !isRunning && remainingSeconds > 0 {
            start()
        }
    }

    // MARK: - Notification Helpers
    func cancelPendingNotification() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["restTimerFinished"])
    }

    func scheduleNotification(at date: Date) {
        guard shouldNotifyOnFinish else { return }

        let content = UNMutableNotificationContent()
        content.title = "Rest Complete"
        content.body = "Your rest timer has finished."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(1, date.timeIntervalSinceNow),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "restTimerFinished",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
