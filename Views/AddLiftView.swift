import SwiftUI

struct AddLiftView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var liftStore: LiftStore

    @State private var exerciseName: String = ""
    @State private var weightText: String = ""
    @State private var repsText: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise")) {
                    TextField("e.g. Bench Press", text: $exerciseName)
                }

                Section(header: Text("Details")) {
                    TextField("Weight (lbs)", text: $weightText)
                        .keyboardType(.decimalPad)

                    TextField("Reps", text: $repsText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("New Lift")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveLift()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        guard !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard Double(weightText) != nil else { return false }
        guard Int(repsText) != nil else { return false }
        return true
    }

    private func saveLift() {
        let trimmedName = exerciseName.trimmingCharacters(in: .whitespaces)
        let weight = Double(weightText) ?? 0
        let reps = Int(repsText) ?? 0

        let newEntry = LiftEntry(
            exerciseName: trimmedName,
            weight: weight,
            reps: reps
        )

        liftStore.entries.append(newEntry)
        dismiss()
    }
}
