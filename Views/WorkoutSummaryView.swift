import SwiftUI

struct WorkoutSummaryView: View {
    var workout: Workout
    var totalSeconds: Int

    // MARK: - Summary Calculations
    var totalExercises: Int {
        workout.exercises.count
    }

    var totalSets: Int {
        workout.exercises.reduce(0) { $0 + $1.sets.count }
    }

    var totalVolume: Double {
        workout.exercises
            .flatMap { $0.sets }
            .reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }

    var body: some View {
        NavigationView {
            List {

                // MARK: - Summary Section
                Section(header: Text("Workout Summary")) {

                    summaryRow(label: "Total Time",
                               value: formatTime(totalSeconds))

                    summaryRow(label: "Exercises",
                               value: "\(totalExercises)")

                    summaryRow(label: "Total Sets",
                               value: "\(totalSets)")

                    summaryRow(label: "Total Volume",
                               value: "\(Int(totalVolume)) lbs")
                }

                // MARK: - Exercises Performed
                Section(header: Text("Exercises Performed")) {
                    ForEach(workout.exercises) { exercise in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.headline)

                            Text("\(exercise.sets.count) sets")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Workout Complete")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismissSheet()
                    }
                }
            }
        }
    }

    // MARK: - Helper Row Builder
    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .bold()
        }
    }

    // MARK: - Time Formatting
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    // MARK: - Dismiss Sheet
    private func dismissSheet() {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .rootViewController?
            .dismiss(animated: true)
    }
}
