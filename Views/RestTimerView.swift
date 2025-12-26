import SwiftUI

struct RestTimerView: View {
    @ObservedObject var timer: RestTimerManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {

            Text("Rest Timer")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(timer.remainingSeconds) seconds")
                .font(.system(size: 48, weight: .bold))
                .monospacedDigit()

            HStack(spacing: 20) {

                Button("Stop") {
                    timer.reset()
                    dismiss()
                }
                .buttonStyle(.bordered)

                Button("Restart 90s") {
                    timer.remainingSeconds = 90
                    timer.totalSeconds = 90
                    timer.start()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
