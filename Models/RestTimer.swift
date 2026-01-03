import Foundation
import Combine

class RestTimer: ObservableObject {
    @Published var remaining: Int = 0
    @Published var isRunning: Bool = false

    private var timer: AnyCancellable?

    func start(seconds: Int) {
        remaining = seconds
        isRunning = true

        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.remaining > 0 {
                    self.remaining -= 1
                } else {
                    self.stop()
                }
            }
    }

    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
}
