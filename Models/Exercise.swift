import Foundation

struct Exercise: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var sets: [ExerciseSet]

    init(id: UUID = UUID(), name: String, sets: [ExerciseSet] = []) {
        self.id = id
        self.name = name
        self.sets = sets
    }
}
