import SwiftUI
import Charts

struct ExerciseStatsView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    let exerciseName: String

    // MARK: - Normalize date to remove time
    func startOfDay(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    // MARK: - Build history using ONLY the last set per workout
    var history: [(date: Date, weight: Double, reps: Int)] {
        workoutStore.workouts.compactMap { workout in
            workout.exercises.first(where: { $0.name == exerciseName })
                .flatMap { exercise in
                    exercise.sets.sorted { $0.date > $1.date }.first
                        .map { set in
                            (
                                date: startOfDay(workout.date),
                                weight: set.weight,
                                reps: set.reps
                            )
                        }
                }
        }
        .sorted { $0.date < $1.date }
    }

    // MARK: - PR detection
    var prWeight: Double {
        history.map { $0.weight }.max() ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Chart
            if history.isEmpty {
                Text("No data available yet.")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
            } else {
                Chart {
                    ForEach(history, id: \.date) { entry in

                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )

                        PointMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .annotation(position: .top) {
                            HStack(spacing: 4) {
                                Text("\(Int(entry.weight)) (\(entry.reps))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)

                                if entry.weight == prWeight {
                                    Text("PR")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 2)
                                        .background(Color.yellow.opacity(0.85))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .frame(height: 250)
                .padding(.vertical)
            }

            // MARK: - List of entries
            List {
                ForEach(history, id: \.date) { entry in
                    HStack {
                        Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text("\(Int(entry.weight)) lbs (\(entry.reps))")

                        if entry.weight == prWeight {
                            Text("PR")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.yellow.opacity(0.85))
                                .cornerRadius(4)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(exerciseName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
