import SwiftUI

struct RestTimerView: View {
    @EnvironmentObject var timer: RestTimerManager   // Shared instance

    var body: some View {
        VStack(spacing: 24) {

            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 4)
                .padding(.top, 8)

            Text("Rest Timer")
                .font(.headline)

            Text(formattedTime)
                .font(.system(size: 42, weight: .bold, design: .monospaced))

            if timer.totalSeconds > 0 {
                let progress = 1 - Double(timer.remainingSeconds) / Double(timer.totalSeconds)
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 80, height: 80)
            }

            HStack(spacing: 16) {
                presetButton(60)
                presetButton(90)
                presetButton(120)
            }

            HStack(spacing: 16) {
                Button {
                    timer.isRunning ? timer.pause() : timer.start()
                } label: {
                    Text(timer.isRunning ? "Pause" : "Start")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button {
                    timer.reset()
                } label: {
                    Text("Reset")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.bottom, 16)

        // MARK: - Bubble Visibility Logic
        .onAppear {
            print("🟦 RestTimerView appeared. Hiding bubble.")
            timer.showFloatingTimer = false
            timer.isBubbleExpanded = false
        }
        .onDisappear {
            print("🟥 RestTimerView disappearing. isRunning:", timer.isRunning, "remaining:", timer.remainingSeconds)

            if timer.isRunning && timer.remainingSeconds > 0 {
                timer.showFloatingTimer = true
                print("🟩 RestTimerView set showFloatingTimer = true")
            } else {
                print("⬜ Bubble NOT shown — timer not active.")
            }
        }
    }

    private func presetButton(_ seconds: Int) -> some View {
        Button {
            timer.setPreset(seconds)
        } label: {
            Text("\(seconds)s")
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }

    private var formattedTime: String {
        let seconds = max(timer.remainingSeconds, 0)
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
