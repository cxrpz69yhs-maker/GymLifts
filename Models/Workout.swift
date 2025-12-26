import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    var date: Date
    var name: String
    var exercises: [Exercise]
    var isFinished: Bool = false
    var duration: TimeInterval = 0
    
    var workoutStartTime: Date?
    var lastOpenedTime: Date?
    var isTimerRunning: Bool = true

    init(id: UUID = UUID(), date: Date, name: String, exercises: [Exercise] = []) {
        self.id = id
        self.date = date
        self.name = name
        self.exercises = exercises
    }
}

extension Workout {
    static let sampleData: [Workout] = [
        Workout(
            date: Date(),
            name: "Push Day",
            exercises: [
                Exercise(
                    name: "Bench Press",
                    sets: [
                        ExerciseSet(weight: 135, reps: 10),
                        ExerciseSet(weight: 155, reps: 8),
                        ExerciseSet(weight: 165, reps: 6)
                    ]
                ),
                Exercise(
                    name: "Incline Dumbbell Press",
                    sets: [
                        ExerciseSet(weight: 50, reps: 12),
                        ExerciseSet(weight: 60, reps: 10)
                    ]
                )
            ]
        ),
        Workout(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            name: "Leg Day",
            exercises: [
                Exercise(
                    name: "Squat",
                    sets: [
                        ExerciseSet(weight: 185, reps: 10),
                        ExerciseSet(weight: 225, reps: 8),
                        ExerciseSet(weight: 245, reps: 5)
                    ]
                ),
                Exercise(
                    name: "Leg Press",
                    sets: [
                        ExerciseSet(weight: 300, reps: 12),
                        ExerciseSet(weight: 340, reps: 10)
                    ]
                )
            ]
        )
    ]
}


