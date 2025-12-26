import SwiftUI

struct AddExerciseView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Environment(\.dismiss) var dismiss

    @Binding var workout: Workout
    @State private var name: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Exercise Name", text: $name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("New Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExercise()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveExercise() {
        let cleanedName = name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized

        if let index = workoutStore.workouts.firstIndex(where: { $0.id == workout.id }) {
            let newExercise = Exercise(name: cleanedName)
            workoutStore.workouts[index].exercises.append(newExercise)
            // Because WorkoutDetailView is bound to workoutStore.workouts[index],
            // this will immediately reflect in the list.
        }
    }
}
