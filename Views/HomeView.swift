import SwiftUI

struct HomeView: View {
    @EnvironmentObject var workoutStore: WorkoutStore

    // Last 5 sets across all workouts
    var recentWorkouts: [Workout] {
        workoutStore.workouts
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }



    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Title
                    Text("Welcome Back")
                        .font(.largeTitle.bold())
                        .padding(.top)
                    
                    // Start Workout Button
                    NavigationLink {
                        AddWorkoutView()
                    } label: {
                        Text("Start Workout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    // Recent Exercises Section
                    // Recent Workouts Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Workouts")
                            .font(.title3.bold())
                        
                        if recentWorkouts.isEmpty {
                            Text("No recent workouts yet.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(recentWorkouts) { workout in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(workout.name)
                                            .font(.headline)
                                        Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(workout.exercises.count) exercises")
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
#Preview {
    HomeView()
        .environmentObject(WorkoutStore())
}

