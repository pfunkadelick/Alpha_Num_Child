import Foundation
import Combine

/// Stars and collected stickers per character, persisted in UserDefaults.
final class ProgressStore: ObservableObject {

    @Published private(set) var stars: [String: Int]
    @Published private(set) var stickers: Set<String>

    private static let starsKey = "characterStars"
    private static let stickersKey = "characterStickers"

    init() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: Self.starsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            stars = decoded
        } else {
            stars = [:]
        }
        if let data = defaults.data(forKey: Self.stickersKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            stickers = decoded
        } else {
            stickers = []
        }
    }

    func stars(for id: String) -> Int {
        stars[id] ?? 0
    }

    func hasSticker(for id: String) -> Bool {
        stickers.contains(id)
    }

    /// Called on completing a character: bumps stars and collects its sticker.
    func award(_ id: String) {
        stars[id] = min(3, (stars[id] ?? 0) + 1)
        stickers.insert(id)
        save()
    }

    func resetAll() {
        stars = [:]
        stickers = []
        save()
    }

    var totalStars: Int {
        stars.values.reduce(0, +)
    }

    var totalStickers: Int {
        stickers.count
    }

    private func save() {
        let defaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(stars) {
            defaults.set(data, forKey: Self.starsKey)
        }
        if let data = try? JSONEncoder().encode(stickers) {
            defaults.set(data, forKey: Self.stickersKey)
        }
    }
}
