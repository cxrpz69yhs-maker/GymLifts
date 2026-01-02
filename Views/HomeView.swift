import SwiftUI

struct HomeView: View {
    @EnvironmentObject var workoutStore: WorkoutStore

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
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Let’s train.")
                            .font(.largeTitle.bold())
                    }
                    .padding(.top, 16)

                    // Start Workout
                    NavigationLink {
                        AddWorkoutView()
                            .environmentObject(workoutStore)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Start Workout")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Create a new workout and start logging sets.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .cornerRadius(20)
                    }

                    // Recent Workouts
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Workouts")
                                .font(.headline)
                            Spacer()
                            NavigationLink {
                                WorkoutsView()
                                    .environmentObject(workoutStore)
                            } label: {
                                Text("See all")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }

                        if recentWorkouts.isEmpty {
                            Text("No recent workouts yet. Start your first one.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(recentWorkouts) { workout in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(workout.name)
                                            .font(.headline)
                                        Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(workout.exercises.count) exercises")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}
