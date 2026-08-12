import AVFoundation
import Foundation

/// Friendly voice prompts and praise using the system speech synthesizer,
/// so the app needs no bundled audio files.
final class SpeechCoach {

    static let shared = SpeechCoach()

    static let soundKey = "soundOn"

    private let synthesizer = AVSpeechSynthesizer()

    private let praises = [
        "Great job!", "You did it!", "Awesome!", "Wow, amazing!",
        "Fantastic!", "Way to go!", "Super!", "Hooray!",
    ]

    private init() {
        UserDefaults.standard.register(defaults: [Self.soundKey: true])
    }

    private var enabled: Bool {
        UserDefaults.standard.bool(forKey: Self.soundKey)
    }

    func say(_ text: String) {
        guard enabled else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.2
        synthesizer.speak(utterance)
    }

    func announce(_ character: TraceCharacter) {
        say("Let's trace \(character.spokenName)!")
    }

    func praise(_ character: TraceCharacter) {
        say("\(praises.randomElement() ?? "Great job!") You wrote \(character.spokenName)!")
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
