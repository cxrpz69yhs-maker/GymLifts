import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Binding var workout: Workout

    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0

    @State private var showingAddExercise = false

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Workout Header
            VStack(spacing: 8) {
                Text(workout.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(formattedDuration)
                    .font(.title2)
                    .monospacedDigit()
                    .padding(.top, 4)

                HStack(spacing: 20) {
                    Button(workout.isTimerRunning ? "Pause" : "Resume") {
                        toggleTimer()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Finish Workout") {
                        finishWorkout()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 6)
            }
            .padding(.vertical, 20)

            Divider()

            // MARK: - Exercise List
            List {
                ForEach($workout.exercises) { $exercise in
                    NavigationLink {
                        ExerciseDetailView(workout: $workout, exercise: $exercise)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.headline)

                            if let lastSet = exercise.sets.last {
                                Text("\(lastSet.weight, specifier: "%.0f") lbs × \(lastSet.reps)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("No sets yet")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteExercises)
            }
        }

        // MARK: - Toolbar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddExercise = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }

        // MARK: - Add Exercise Sheet
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(workout: $workout)
                .environmentObject(workoutStore)
        }

        .onAppear { startTimerIfNeeded() }
        .onDisappear { workout.lastOpenedTime = Date() }
    }

    // MARK: - Timer Logic

    var formattedDuration: String {
        let total = workout.duration + elapsedTime
        let minutes = Int(total) / 60
        let seconds = Int(total) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimerIfNeeded() {
        if workout.isTimerRunning {
            workout.workoutStartTime = workout.workoutStartTime ?? Date()
            workout.lastOpenedTime = Date()
            startTimer()
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard workout.isTimerRunning else { return }
            elapsedTime += 1
        }
    }

    func toggleTimer() {
        workout.isTimerRunning.toggle()
        if workout.isTimerRunning {
            startTimer()
        } else {
            timer?.invalidate()
            workout.duration += elapsedTime
            elapsedTime = 0
        }
    }

    func finishWorkout() {
        timer?.invalidate()
        workout.isFinished = true
        workout.duration += elapsedTime
        elapsedTime = 0
    }

    private func deleteExercises(at offsets: IndexSet) {
        workout.exercises.remove(atOffsets: offsets)
    }
}

