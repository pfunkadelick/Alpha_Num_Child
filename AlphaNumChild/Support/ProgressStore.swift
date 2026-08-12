import Foundation
import Combine

/// Stars earned per character, persisted in UserDefaults.
final class ProgressStore: ObservableObject {

    @Published private(set) var stars: [String: Int]

    private static let key = "characterStars"

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.key),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            stars = decoded
        } else {
            stars = [:]
        }
    }

    func stars(for id: String) -> Int {
        stars[id] ?? 0
    }

    func award(_ id: String) {
        stars[id] = min(3, (stars[id] ?? 0) + 1)
        save()
    }

    func resetAll() {
        stars = [:]
        save()
    }

    var totalStars: Int {
        stars.values.reduce(0, +)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(stars) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }
}
