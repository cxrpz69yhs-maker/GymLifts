import Foundation

struct LiftEntry: Identifiable, Codable {
    let id: UUID
    var exerciseName: String
    var weight: Double
    var reps: Int
    var date: Date

    init(
        id: UUID = UUID(),
        exerciseName: String,
        weight: Double,
        reps: Int,
        date: Date = Date()
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.weight = weight
        self.reps = reps
        self.date = date
    }
}
