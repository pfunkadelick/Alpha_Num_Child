import Foundation

/// Phonics rewards: every character earns a collectible sticker.
/// Letters pair with a word that starts with their sound ("A is for apple"),
/// numbers pair with a counted set of objects ("Three apples!").
enum Rewards {

    struct Reward {
        /// What the celebration shows (may repeat an emoji for numbers).
        let display: String
        /// Single emoji shown in the sticker book.
        let sticker: String
        /// Spoken + shown phrase, e.g. "A is for apple!"
        let phrase: String
    }

    private static let letterWords: [String: (emoji: String, word: String)] = [
        "A": ("🍎", "apple"),    "B": ("🐻", "bear"),     "C": ("🐱", "cat"),
        "D": ("🐶", "dog"),      "E": ("🐘", "elephant"), "F": ("🐟", "fish"),
        "G": ("🦒", "giraffe"),  "H": ("🐴", "horse"),    "I": ("🍦", "ice cream"),
        "J": ("🧃", "juice"),    "K": ("🪁", "kite"),     "L": ("🦁", "lion"),
        "M": ("🐵", "monkey"),   "N": ("🪺", "nest"),     "O": ("🐙", "octopus"),
        "P": ("🐧", "penguin"),  "Q": ("👸", "queen"),    "R": ("🌈", "rainbow"),
        "S": ("🐍", "snake"),    "T": ("🐢", "turtle"),   "U": ("☂️", "umbrella"),
        "V": ("🎻", "violin"),   "W": ("🐳", "whale"),    "X": ("🩻", "x-ray"),
        "Y": ("🪀", "yo-yo"),    "Z": ("🦓", "zebra"),
    ]

    private static let numberWords: [(emoji: String, singular: String, plural: String)] = [
        ("🍩", "donut", "donuts"),        // 0 — "zero looks like a donut!"
        ("🚀", "rocket", "rockets"),      // 1
        ("🦆", "duck", "ducks"),          // 2
        ("🍎", "apple", "apples"),        // 3
        ("🐸", "frog", "frogs"),          // 4
        ("⭐", "star", "stars"),          // 5
        ("🐠", "fish", "fish"),           // 6
        ("🎈", "balloon", "balloons"),    // 7
        ("🍪", "cookie", "cookies"),      // 8
        ("🐞", "ladybug", "ladybugs"),    // 9
    ]

    static func reward(for character: TraceCharacter) -> Reward {
        if character.id.hasPrefix("N-"), let n = Int(character.glyph),
           n >= 0, n < numberWords.count {
            let entry = numberWords[n]
            if n == 0 {
                return Reward(display: entry.emoji, sticker: entry.emoji,
                              phrase: "Zero looks like a donut — zero means none!")
            }
            let word = n == 1 ? entry.singular : entry.plural
            return Reward(display: String(repeating: entry.emoji, count: n),
                          sticker: entry.emoji,
                          phrase: "\(character.spokenName.capitalized) \(word)!")
        }

        let key = character.glyph.uppercased()
        let entry = letterWords[key] ?? ("⭐", "star")
        return Reward(display: entry.emoji, sticker: entry.emoji,
                      phrase: "\(character.glyph) is for \(entry.word)!")
    }
}
