import SwiftUI

struct InfiniteRing: View {
    @Binding var isRunning: Bool
    @Binding var remainingSeconds: Int
    var totalSeconds: Int

    @State private var rotation: Double = 0

    var size: CGFloat = 120
    var lineWidth: CGFloat = 10

    private var ringColor: Color {
        let ratio = Double(remainingSeconds) / Double(totalSeconds)

        switch ratio {
        case 0.5...1:
            return .green
        case 0.25..<0.5:
            return .yellow
        case 0.1..<0.25:
            return .orange
        default:
            return .red
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
                .animation(
                    isRunning
                    ? .linear(duration: 1.5).repeatForever(autoreverses: false)
                    : .default,
                    value: rotation
                )
        }
        .frame(width: size, height: size)
        .onChange(of: isRunning) { _, newValue in
            rotation = newValue ? 360 : 0
        }
    }
}
