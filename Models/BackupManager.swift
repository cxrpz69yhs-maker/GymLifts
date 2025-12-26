import Foundation

struct WorkoutBackup: Codable {
    let workouts: [Workout]
    let date: Date
}

extension WorkoutStore {

    // Save backup to a file
    func saveBackup() {
        let backup = WorkoutBackup(workouts: workouts, date: Date())
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(backup)
            try data.write(to: backupURL())
            print("✅ Backup saved")
        } catch {
            print("❌ Backup failed:", error)
        }
    }

    // Load backup from file
    func loadBackup() {
        do {
            let data = try Data(contentsOf: backupURL())
            let backup = try JSONDecoder().decode(WorkoutBackup.self, from: data)
            self.workouts = backup.workouts
            print("✅ Backup loaded")
        } catch {
            print("❌ Load failed:", error)
        }
    }

    private func backupURL() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("WorkoutBackup.json")
    }
}
