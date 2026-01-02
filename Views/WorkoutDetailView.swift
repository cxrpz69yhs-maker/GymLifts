import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Binding var workout: Workout

    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0
    @State private var showingAddExercise = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(workout.name)
                        .font(.largeTitle.bold())

                    Text(formattedDuration)
                        .font(.title2.monospacedDigit())

                    HStack(spacing: 12) {
                        Button(workout.isTimerRunning ? "Pause" : "Resume") {
                            toggleTimer()
                        }
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                        Button("Finish") {
                            finishWorkout()
                        }
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 16)

                // Exercises
                VStack(alignment: .leading, spacing: 12) {
                    Text("Exercises")
                        .font(.headline)
                        .padding(.horizontal)

                    if workout.exercises.isEmpty {
                        Text("No exercises yet. Add one to get started.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else {
                        ForEach($workout.exercises) { $exercise in
                            NavigationLink {
                                ExerciseDetailView(workout: $workout, exercise: $exercise)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(exercise.name)
                                            .font(.headline)

                                        if let lastSet = exercise.sets.sorted(by: { $0.date > $1.date }).first {
                                            Text("\(lastSet.weight, specifier: "%.0f") lbs × \(lastSet.reps) reps")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text("No sets yet")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddExercise = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(workout: $workout)
                .environmentObject(workoutStore)
                .presentationDetents([.fraction(0.4), .medium])
                .presentationDragIndicator(.visible)
        }
        .onAppear { startTimerIfNeeded() }
        .onDisappear { workout.lastOpenedTime = Date() }
    }

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
}

