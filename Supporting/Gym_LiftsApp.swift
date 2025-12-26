import SwiftUI

@main
struct GymLiftsApp: App {
    @StateObject private var workoutStore = WorkoutStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(workoutStore)
        }
    }
}
