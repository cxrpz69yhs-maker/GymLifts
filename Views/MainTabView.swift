import SwiftUI

struct MainTabView: View {
    var body: some View {
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
    }
}
