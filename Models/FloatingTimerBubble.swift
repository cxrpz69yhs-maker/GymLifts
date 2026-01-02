import SwiftUI

struct FloatingTimerBubble: View {
    @EnvironmentObject var restTimer: RestTimerManager

    @GestureState private var dragOffset: CGSize = .zero
    @State private var position: CGPoint = CGPoint(x: 120, y: 200)
    @State private var expanded: Bool = false   // Dynamic Island expansion

    var body: some View {
        ZStack {
            // Floating bubble / expanded island
            ZStack {
                if expanded {
                    // Expanded Dynamic Island
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .frame(width: 260, height: 110)
                        .shadow(radius: 10)

                    VStack(spacing: 12) {

                        // Top row: timer + reset
                        HStack(spacing: 16) {
                            Text(timeString)
                                .font(.system(size: 28, weight: .bold, design: .monospaced))

                            Spacer()

                            // X resets the timer
                            Button {
                                restTimer.reset()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)

                        // Bottom row: quick-add bubbles
                        HStack(spacing: 14) {
                            quickAddBubble(15)
                            quickAddBubble(30)
                            quickAddBubble(60)
                        }
                    }

                } else {
                    // Circular bubble
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 10)
                        .overlay(
                            Text(timeString)
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.primary)
                        )
                }
            }
            .frame(width: expanded ? 260 : 70, height: expanded ? 110 : 70)
            .clipShape(RoundedRectangle(cornerRadius: expanded ? 30 : 35, style: .continuous))
            .position(position)
            .offset(dragOffset)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: expanded)
            .animation(.spring(), value: dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        position.x += value.translation.width
                        position.y += value.translation.height
                    }
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expanded.toggle()
                }
            }
        }
    }

    // MARK: - Quick Add Bubble
    private func quickAddBubble(_ seconds: Int) -> some View {
        Button {
            restTimer.add(seconds: seconds)
        } label: {
            Text("+\(seconds)")
                .font(.system(size: 14, weight: .semibold))
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
    }

    // MARK: - Time Formatting
    private var timeString: String {
        let s = max(restTimer.remainingSeconds, 0)
        let m = s / 60
        let sec = s % 60
        return String(format: "%d:%02d", m, sec)
    }
}

