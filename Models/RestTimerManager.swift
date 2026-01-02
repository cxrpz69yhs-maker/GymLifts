import Foundation
import Combine
import UIKit
import UserNotifications
import AudioToolbox

class RestTimerManager: ObservableObject {
    @Published var shouldNotifyOnFinish: Bool = true
    @Published var remainingSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var totalSeconds: Int = 0
    @Published var targetEndTime: Date?

    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    init() {
        observeAppLifecycle()
    }

    // MARK: - Observe App Lifecycle
    private func observeAppLifecycle() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.handleAppBecameActive()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.handleAppWillResignActive()
            }
            .store(in: &cancellables)
    }

    private func handleAppBecameActive() {
        guard let end = targetEndTime else { return }

        let diff = Int(end.timeIntervalSinceNow)

        if diff > 0 {
            remainingSeconds = diff
            if isRunning {
                startTicking()
            }
        } else {
            finishTimer()
        }
    }

    private func handleAppWillResignActive() {
        // Stop the in-app ticking loop (iOS will suspend anyway)
        timer?.cancel()
        timer = nil
    }

    // MARK: - Start Timer
    func start() {
        guard remainingSeconds > 0 else { return }

        if totalSeconds == 0 {
            totalSeconds = remainingSeconds
        }

        targetEndTime = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        isRunning = true

        scheduleNotificationIfNeeded()
        startTicking()
    }

    private func startTicking() {
        timer?.cancel()

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateRemainingTime()
            }
    }

    private func updateRemainingTime() {
        guard let end = targetEndTime else { return }

        let diff = Int(end.timeIntervalSinceNow)

        if diff > 0 {
            remainingSeconds = diff
        } else {
            finishTimer()
        }
    }

    // MARK: - Finish
    private func finishTimer() {
        remainingSeconds = 0
        isRunning = false
        timer?.cancel()
        timer = nil

        vibrate()
        cancelPendingNotification()
    }

    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    // MARK: - Pause
    func pause() {
        isRunning = false
        timer?.cancel()
        timer = nil
        cancelPendingNotification()
    }

    // MARK: - Reset
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

        if isRunning {
            targetEndTime = Date().addingTimeInterval(TimeInterval(remainingSeconds))
            scheduleNotificationIfNeeded()
        }
    }

    // MARK: - Notifications
    private func scheduleNotificationIfNeeded() {
        guard shouldNotifyOnFinish, let end = targetEndTime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Rest Complete"
        content.body = "Your rest timer has finished."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(1, end.timeIntervalSinceNow),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "restTimerFinished",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelPendingNotification() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["restTimerFinished"])
    }
}
