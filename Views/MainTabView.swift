import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var restTimer: RestTimerManager

    var body: some View {
        ZStack {
            // Main app content
            TabView {

                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }

                NavigationStack {
                    WorkoutsView()
                }
                .tabItem {
                    Label("Workouts", systemImage: "figure.strengthtraining.traditional")
                }

                NavigationStack {
                    ExerciseLibraryView()
                }
                .tabItem {
                    Label("Exercises", systemImage: "list.bullet")
                }
            }

            // Tap-anywhere-to-collapse layer (only when bubble is expanded)
            if restTimer.showFloatingTimer && restTimer.isBubbleExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        NotificationCenter.default.post(
                            name: .collapseFloatingTimer,
                            object: nil
                        )
                    }
                    .zIndex(5)
            }

            // Floating timer bubble overlay
            if restTimer.showFloatingTimer {
                FloatingTimerBubble()
                    .environmentObject(restTimer)
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: restTimer.showFloatingTimer)
        .animation(.easeInOut(duration: 0.25), value: restTimer.isBubbleExpanded)
    }
}
