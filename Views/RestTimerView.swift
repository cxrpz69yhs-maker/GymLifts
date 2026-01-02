import SwiftUI

struct RestTimerView: View {
    @ObservedObject var timer: RestTimerManager

    var body: some View {
        VStack(spacing: 24) {
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 4)
                .padding(.top, 8)

            Text("Rest Timer")
                .font(.headline)

            // Timer display
            Text(formattedTime)
                .font(.system(size: 42, weight: .bold, design: .monospaced))

            // Progress Ring
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

            // Presets
            HStack(spacing: 16) {
                presetButton(60)
                presetButton(90)
                presetButton(120)
            }

            // Controls
            HStack(spacing: 16) {
                Button {
                    if timer.isRunning {
                        timer.pause()
                    } else {
                        timer.start()
                    }
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
    }

    private func presetButton(_ seconds: Int) -> some View {
        Button {
            timer.totalSeconds = seconds
            timer.remainingSeconds = seconds
            timer.start()
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
