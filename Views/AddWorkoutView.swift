import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var date: Date = Date()

    var body: some View {
        VStack(spacing: 28) {

            // Title
            Text("New Workout")
                .font(.largeTitle.bold())
                .padding(.top, 20)

            // Inputs
            VStack(alignment: .leading, spacing: 16) {

                // Workout Name
                VStack(alignment: .leading, spacing: 6) {
                    Text("Workout Name")
                        .font(.headline)

                    TextField("Leg Day, Push, Pull...", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                // Date Picker
                VStack(alignment: .leading, spacing: 6) {
                    Text("Date")
                        .font(.headline)

                    DatePicker("", selection: $date, displayedComponents: .date)
                        .labelsHidden()
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            Spacer()

            // Save Button
            Button {
                let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }

                let newWorkout = Workout(
                    date: date,
                    name: trimmed,
                    exercises: []
                )

                workoutStore.workouts.append(newWorkout)
                workoutStore.save()
                dismiss()

            } label: {
                Text("Save Workout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            // Cancel Button
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.red)
            .padding(.bottom, 20)
        }
    }
}

