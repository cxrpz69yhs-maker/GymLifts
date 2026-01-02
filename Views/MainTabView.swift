import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var restTimer: RestTimerManager

    var body: some View {
        ZStack {
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

            // Tap anywhere to collapse bubble
            if restTimer.showFloatingTimer && restTimer.isBubbleExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        NotificationCenter.default.post(name: .collapseFloatingTimer, object: nil)
                    }
                    .zIndex(5)
            }

            if restTimer.showFloatingTimer {
                FloatingTimerBubble()
                    .environmentObject(restTimer)
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: restTimer.showFloatingTimer)
        .animation(.easeInOut(duration: 0.25), value: restTimer.isBubbleExpanded)

        // 🔥 DEBUG PRINT
        .onChange(of: restTimer.showFloatingTimer) { oldValue, newValue in
            print("🔥 MainTabView sees showFloatingTimer =", newValue)
        }
    }
}
