import AVFoundation
import Foundation

/// Friendly voice prompts and praise using the system speech synthesizer,
/// so the app needs no bundled audio files.
///
/// Voice quality note: the app automatically picks the warmest, most
/// natural English voice installed on the device — premium and enhanced
/// voices win over the default robotic one. For the best result, download
/// a premium voice once per phone in Settings > Accessibility >
/// Spoken Content > Voices > English (e.g. "Ava (Premium)"); the app
/// will find and use it automatically.
final class SpeechCoach {

    static let shared = SpeechCoach()

    static let soundKey = "soundOn"

    private let synthesizer = AVSpeechSynthesizer()

    private lazy var voice: AVSpeechSynthesisVoice? = Self.warmestVoice()

    private let praises = [
        "Wonderful, sweetheart!", "You did it, sweetie!", "Beautiful writing!",
        "I'm so proud of you!", "That was lovely!", "You're doing so well!",
        "Great job, my dear!", "Hooray, sweetie!",
    ]

    private let invitations = [
        "Let's trace %@ together!", "Can you trace %@ with me?",
        "Time to trace %@, sweetie!", "Here comes %@. Ready?",
    ]

    private init() {
        UserDefaults.standard.register(defaults: [Self.soundKey: true])
    }

    /// The most natural-sounding English voice available on this device:
    /// premium beats enhanced beats compact, warm female voices are
    /// preferred, and well-liked Apple voices rank highest.
    private static func warmestVoice() -> AVSpeechSynthesisVoice? {
        let preferredNames = ["ava", "samantha", "zoe", "allison", "susan",
                              "nicky", "serena", "kate", "karen", "moira", "tessa"]
        let maleNames = ["aaron", "alex", "arthur", "daniel", "fred", "gordon",
                         "reed", "rocko", "eddy", "albert", "bruce", "junior",
                         "ralph", "grandpa", "oliver", "thomas"]
        let candidates = AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.hasPrefix("en") }

        func score(_ v: AVSpeechSynthesisVoice) -> Int {
            var s = 0
            let name = v.name.lowercased()
            switch v.quality {
            case .premium: s += 40
            case .enhanced: s += 30
            default: break
            }
            if v.gender == .female { s += 20 }
            if v.gender == .male || maleNames.contains(where: { name.contains($0) }) { s -= 60 }
            if let i = preferredNames.firstIndex(where: { name.contains($0) }) {
                s += (preferredNames.count - i) * 2 + 10
            }
            if v.language == "en-US" { s += 4 }
            return s
        }

        return candidates.max(by: { score($0) < score($1) })
            ?? AVSpeechSynthesisVoice(language: "en-US")
    }

    private var enabled: Bool {
        UserDefaults.standard.bool(forKey: Self.soundKey)
    }

    func say(_ text: String) {
        guard enabled else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        // Gentle, motherly delivery: near-natural pitch (a big pitch boost
        // is what makes synthesized speech sound robotic) and an unhurried,
        // soothing rate for little ears.
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.02
        utterance.postUtteranceDelay = 0.15
        synthesizer.speak(utterance)
    }

    func announce(_ character: TraceCharacter) {
        let template = invitations.randomElement() ?? "Let's trace %@ together!"
        say(String(format: template, character.spokenName))
    }

    func praise(_ character: TraceCharacter) {
        let phrase = Rewards.reward(for: character).phrase
        say("\(praises.randomElement() ?? "Great job!") You wrote \(character.spokenName)! \(phrase)")
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
