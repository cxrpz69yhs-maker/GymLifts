import SwiftUI

struct EditSetView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    var exercise: Exercise
    @Binding var workout: Workout
    var set: ExerciseSet

    @ObservedObject var restTimerManager: RestTimerManager

    @State private var weight: String = ""
    @State private var reps: String = ""

    var body: some View {
        Form {
            Section(header: Text("Edit Set")) {
                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)

                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
            }

            Section {
                Button("Save Changes") {
                    saveChanges()
                }
            }
        }
        .navigationTitle("Edit Set")
        .onAppear {
            weight = "\(set.weight)"
            reps = "\(set.reps)"
        }
    }

    private func saveChanges() {
        guard let workoutIndex = workoutStore.workouts.firstIndex(where: { $0.id == workout.id }),
              let exerciseIndex = workoutStore.workouts[workoutIndex].exercises.firstIndex(where: { $0.id == exercise.id }),
              let setIndex = workoutStore.workouts[workoutIndex].exercises[exerciseIndex].sets.firstIndex(where: { $0.id == set.id }),
              let newWeight = Double(weight),
              let newReps = Int(reps)
        else { return }

        workoutStore.workouts[workoutIndex].exercises[exerciseIndex].sets[setIndex].weight = newWeight
        workoutStore.workouts[workoutIndex].exercises[exerciseIndex].sets[setIndex].reps = newReps
    }
}

