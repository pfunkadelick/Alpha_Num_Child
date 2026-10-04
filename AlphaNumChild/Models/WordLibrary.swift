import CoreGraphics

/// Simple two- and three-letter words for early spelling, built by laying
/// the lowercase letter strokes side by side. Each word pairs with a
/// picture so completing it teaches meaning along with spelling.
enum WordLibrary {

    static let entries: [(word: String, emoji: String)] = [
        // Two-letter words
        ("up", "⬆️"), ("go", "🚦"), ("me", "🙋"), ("no", "🙅"),
        ("hi", "👋"), ("ox", "🐂"),
        // Three-letter words
        ("cat", "🐱"), ("dog", "🐶"), ("sun", "☀️"), ("bus", "🚌"),
        ("hat", "🎩"), ("pig", "🐷"), ("cow", "🐮"), ("bee", "🐝"),
        ("car", "🚗"), ("egg", "🥚"), ("cup", "☕"), ("bed", "🛏️"),
        ("fox", "🦊"), ("owl", "🦉"),
    ]

    static let words: [TraceCharacter] = entries.map(build)

    static func emoji(for word: String) -> String {
        entries.first { $0.word == word }?.emoji ?? "⭐"
    }

    private static func build(_ entry: (word: String, emoji: String)) -> TraceCharacter {
        let letters = entry.word.map { ch in
            CharacterLibrary.lowercase.first { $0.glyph == String(ch) }!
        }
        let count = CGFloat(letters.count)
        // Letters overlap their slots' side padding (pitch < scale) so the
        // word reads tightly and each letter can render a bit larger.
        let scale = 0.98 / (1 + 0.78 * (count - 1))
        let pitch = 0.78 * scale
        let xStart = (1 - (scale + pitch * (count - 1))) / 2
        let yOffset = (1 - scale) / 2   // center the word band vertically

        var strokes: [TraceStroke] = []
        var letterEnds: [Int] = []
        for (index, letter) in letters.enumerated() {
            let xOffset = xStart + CGFloat(index) * pitch
            for stroke in letter.strokes {
                let points = stroke.points.map {
                    CGPoint(x: xOffset + $0.x * scale, y: yOffset + $0.y * scale)
                }
                strokes.append(TraceStroke(points, isDot: stroke.isDot))
            }
            letterEnds.append(strokes.count)
        }
        letterEnds.removeLast()   // the final letter is announced by the praise

        // Lowercase guide lines (ascender, x-height, baseline), scaled
        // into the word band.
        let guides = [0.15, 0.42, 0.78].map { yOffset + $0 * scale }

        return TraceCharacter(id: "W-\(entry.word)",
                              glyph: entry.word,
                              spokenName: "the word \(entry.word)",
                              traceStrokes: strokes,
                              guideLines: guides,
                              letterEnds: letterEnds,
                              toleranceFactor: min(1, scale + 0.25))
    }
}
