import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var date: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Name")) {
                    TextField("e.g. Push Day", text: $name)
                }

                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New Workout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newWorkout = Workout(
                            date: date,
                            name: name,
                            exercises: []
                        )
                        workoutStore.workouts.append(newWorkout)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
}
