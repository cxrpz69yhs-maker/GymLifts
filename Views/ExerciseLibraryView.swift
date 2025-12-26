import SwiftUI

struct ExerciseLibraryView: View {
    @EnvironmentObject var workoutStore: WorkoutStore

    // MARK: - Unique Exercise Names
    var allExerciseNames: [String] {
        let names = workoutStore.workouts.flatMap { workout in
            workout.exercises.map { $0.name }
        }
        return Array(Set(names)).sorted()
    }

    var body: some View {
        NavigationStack {
            List {
                if allExerciseNames.isEmpty {
                    Text("No exercises logged yet.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(allExerciseNames, id: \.self) { name in
                        NavigationLink {
                            ExerciseStatsView(exerciseName: name)
                        } label: {
                            Text(name)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Exercise Library")
        }
    }
}
