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

            // Tap anywhere to collapse the expanded bubble
            if restTimer.showFloatingTimer {
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
                    .transition(.scale)
                    .zIndex(10)
            }
        }
    }
}
