import SwiftUI

struct AddSetView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Environment(\.dismiss) var dismiss

    @Binding var workout: Workout
    @Binding var exercise: Exercise

    @State private var weight: String = ""
    @State private var reps: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Weight") {
                    TextField("lbs", text: $weight)
                        .keyboardType(.decimalPad)
                }

                Section("Reps") {
                    TextField("Reps", text: $reps)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("New Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSet()
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        guard let w = Double(weight), w > 0 else { return false }
        guard let r = Int(reps), r > 0 else { return false }
        return true
    }

    private func saveSet() {
        guard let w = Double(weight), let r = Int(reps) else { return }

        workoutStore.addSet(
            to: exercise,
            in: workout,
            weight: w,
            reps: r
        )
    }
}

