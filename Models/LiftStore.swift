import Foundation
import SwiftUI
import Combine

class LiftStore: ObservableObject {
    @Published var entries: [LiftEntry] = [] {
        didSet {
            save()
        }
    }

    private let saveKey = "liftEntries"

    init() {
        load()
    }

    private func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            entries = []
            return
        }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([LiftEntry].self, from: data) {
            entries = decoded
        } else {
            entries = []
        }
    }
}
