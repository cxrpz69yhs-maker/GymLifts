import SwiftUI

@main
struct GymLiftsApp: App {
    @StateObject private var workoutStore = WorkoutStore()
    @StateObject private var restTimer = RestTimerManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(workoutStore)
                .environmentObject(restTimer)
            
        }
    }
}

