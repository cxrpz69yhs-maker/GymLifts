import Foundation
import Combine

class WorkoutTimerManager: ObservableObject {
    @Published var elapsedSeconds: Int = 0
    @Published var isRunning: Bool = false

    private var timer: AnyCancellable?

    func start() {
        guard !isRunning else { return }
        isRunning = true

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.elapsedSeconds += 1
            }
    }

    func pause() {
        isRunning = false
        timer?.cancel()
    }

    func reset() {
        pause()
        elapsedSeconds = 0
    }
}
