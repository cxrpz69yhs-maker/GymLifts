import Foundation

struct ExerciseSet: Identifiable, Codable {
    var id: UUID = UUID()
    var weight: Double
    var reps: Int
    var date: Date = Date()

    init(id: UUID = UUID(), weight: Double, reps: Int, date: Date = Date()) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.date = date
    }
}
