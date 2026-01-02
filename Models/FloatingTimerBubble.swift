import SwiftUI

struct FloatingTimerBubble: View {
    @EnvironmentObject var restTimer: RestTimerManager

    @GestureState private var dragOffset: CGSize = .zero
    @State private var position: CGPoint = CGPoint(x: 120, y: 200)
    @State private var expanded: Bool = false

    var body: some View {
        ZStack {
            ZStack {
                if expanded {
                    expandedIsland
                } else {
                    collapsedBubble
                }
            }
            .frame(width: expanded ? 260 : 70, height: expanded ? 110 : 70)
            .contentShape(RoundedRectangle(cornerRadius: expanded ? 30 : 35, style: .continuous))
            .background(Color.clear)
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
                    restTimer.isBubbleExpanded = expanded
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .collapseFloatingTimer)) { _ in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expanded = false
                    restTimer.isBubbleExpanded = false
                }
            }
        }
    }

    private var expandedIsland: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    Text(timeString)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)

                    Spacer()

                    Button {
                        restTimer.reset()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 20)

                HStack(spacing: 14) {
                    quickAddBubble(15)
                    quickAddBubble(30)
                    quickAddBubble(60)
                }
            }
        }
    }

    private var collapsedBubble: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .shadow(radius: 10)
            .overlay(
                Text(timeString)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            )
    }

    private func quickAddBubble(_ seconds: Int) -> some View {
        Button {
            restTimer.add(seconds: seconds)
        } label: {
            Text("+\(seconds)")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
    }

    private var timeString: String {
        let s = max(restTimer.remainingSeconds, 0)
        let m = s / 60
        let sec = s % 60
        return String(format: "%d:%02d", m, sec)
    }
}

extension Notification.Name {
    static let collapseFloatingTimer = Notification.Name("collapseFloatingTimer")
}
