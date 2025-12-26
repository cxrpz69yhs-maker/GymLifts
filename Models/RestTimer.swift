import Foundation
import Combine

class RestTimer: ObservableObject {
    @Published var remaining: Int = 0
    @Published var isRunning = false

    private var timer: Timer?

    func start(seconds: Int) {
        remaining = seconds
        isRunning = true

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remaining > 0 {
                self.remaining -= 1
            } else {
                self.stop()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        isRunning = false
    }
}
