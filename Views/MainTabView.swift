import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var restTimer: RestTimerManager   // ← add this

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
