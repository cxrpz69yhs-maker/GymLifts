import Foundation
import Combine
import SwiftUI

class WorkoutStore: ObservableObject {
    @Published var workouts: [Workout] = []

    init() {
        // Try to load saved workouts
        let loaded = load()

        // If nothing was loaded, use sample data
        if !loaded {
            workouts = Workout.sampleData
            save() // persist sample data so it sticks
        }
    }

    // MARK: - Workouts

    func addWorkout(name: String) {
        let newWorkout = Workout(
            date: Date(),
            name: name,
            exercises: []
        )
        workouts.append(newWorkout)
        save()
    }

    func deleteWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Exercises

    func addExercise(to workout: Workout, name: String) {
        guard let index = workouts.firstIndex(where: { $0.id == workout.id }) else { return }

        let newExercise = Exercise(
            name: name,
            sets: []
        )

        workouts[index].exercises.append(newExercise)
        save()
    }

    func deleteExercise(from workout: Workout, exercise: Exercise) {
        guard let workoutIndex = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        guard let exerciseIndex = workouts[workoutIndex].exercises.firstIndex(where: { $0.id == exercise.id }) else { return }

        workouts[workoutIndex].exercises.remove(at: exerciseIndex)
        save()
    }

    func updateExerciseName(workout: Workout, exercise: Exercise, newName: String) {
        guard let workoutIndex = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        guard let exerciseIndex = workouts[workoutIndex].exercises.firstIndex(where: { $0.id == exercise.id }) else { return }

        let cleanedName = newName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized

        workouts[workoutIndex].exercises[exerciseIndex].name = cleanedName
        save()
    }

    // MARK: - Sets

    func addSet(to exercise: Exercise, in workout: Workout, weight: Double, reps: Int) {
        guard let workoutIndex = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        guard let exerciseIndex = workouts[workoutIndex].exercises.firstIndex(where: { $0.id == exercise.id }) else { return }

        let newSet = ExerciseSet(
            weight: weight,
            reps: reps
        )

        workouts[workoutIndex].exercises[exerciseIndex].sets.append(newSet)
        save()
    }

    func deleteSet(_ set: ExerciseSet, from exercise: Exercise, in workout: Workout) {
        guard let workoutIndex = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        guard let exerciseIndex = workouts[workoutIndex].exercises.firstIndex(where: { $0.id == exercise.id }) else { return }
        guard let setIndex = workouts[workoutIndex].exercises[exerciseIndex].sets.firstIndex(where: { $0.id == set.id }) else { return }

        workouts[workoutIndex].exercises[exerciseIndex].sets.remove(at: setIndex)
        save()
    }

    // MARK: - Persistence

    func save() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: "workouts")
        }
    }

    /// Returns true if data was successfully loaded, false if no saved data exists.
    @discardableResult
    private func load() -> Bool {
        if
            let data = UserDefaults.standard.data(forKey: "workouts"),
            let decoded = try? JSONDecoder().decode([Workout].self, from: data)
        {
            workouts = decoded
            return true
        }

        return false
    }
}
