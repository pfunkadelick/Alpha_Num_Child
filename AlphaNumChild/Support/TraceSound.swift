import AVFoundation
import Foundation

/// Continuous audio guidance while tracing — an audio "heat map":
/// - On the line: a warm tone that climbs a pentatonic scale as the
///   stroke progresses, so finishing a stroke sounds like a little melody.
/// - Off the line: a soft low wobble that gets louder the farther the
///   finger strays, and fades away as it comes back to the track.
/// - Stroke finished: a bright two-note chime.
///
/// Everything is synthesized live with AVAudioEngine, so no audio files
/// are needed. Uses the .ambient session so it respects the silent switch
/// and mixes with the speech coach.
final class TraceSound {

    static let shared = TraceSound()

    private let engine = AVAudioEngine()
    private var configured = false

    // Targets written on the main thread and read by the audio render
    // thread; per-sample smoothing below removes any clicks.
    private var goodTargetAmp: Float = 0
    private var goodTargetFreq: Float = 523.25
    private var warnTargetAmp: Float = 0

    /// C major pentatonic — always sounds pleasant in any order.
    private let scale: [Float] = [523.25, 587.33, 659.25, 783.99, 880.0, 1046.5]

    private init() {}

    private var enabled: Bool {
        UserDefaults.standard.bool(forKey: SpeechCoach.soundKey)
    }

    private func configureIfNeeded() {
        guard !configured else { return }
        configured = true
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)

        let sampleRate: Float = 44100
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)

        // Warm "on the line" tone: sine plus a quiet octave harmonic.
        var goodPhase: Float = 0
        var goodAmp: Float = 0
        var goodFreq: Float = 523.25
        let good = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList in
            let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let targetAmp = self?.goodTargetAmp ?? 0
            let targetFreq = self?.goodTargetFreq ?? 523.25
            for frame in 0..<Int(frameCount) {
                goodAmp += (targetAmp - goodAmp) * 0.0015
                goodFreq += (targetFreq - goodFreq) * 0.002
                goodPhase += goodFreq * 2 * .pi / sampleRate
                if goodPhase > 2 * .pi { goodPhase -= 2 * .pi }
                let value = (sin(goodPhase) + 0.3 * sin(goodPhase * 2)) * goodAmp
                for buffer in buffers {
                    buffer.mData?.assumingMemoryBound(to: Float.self)[frame] = value
                }
            }
            return noErr
        }

        // Gentle "come back" wobble: low triangle wave with a 7 Hz tremolo.
        var warnPhase: Float = 0
        var tremoloPhase: Float = 0
        var warnAmp: Float = 0
        let warn = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList in
            let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let targetAmp = self?.warnTargetAmp ?? 0
            for frame in 0..<Int(frameCount) {
                warnAmp += (targetAmp - warnAmp) * 0.0015
                warnPhase += 165 * 2 * .pi / sampleRate
                if warnPhase > 2 * .pi { warnPhase -= 2 * .pi }
                tremoloPhase += 7 * 2 * .pi / sampleRate
                if tremoloPhase > 2 * .pi { tremoloPhase -= 2 * .pi }
                let normalized = warnPhase / (2 * .pi)
                let triangle = 4 * abs(normalized - 0.5) - 1
                let value = triangle * warnAmp * (0.65 + 0.35 * sin(tremoloPhase))
                for buffer in buffers {
                    buffer.mData?.assumingMemoryBound(to: Float.self)[frame] = value
                }
            }
            return noErr
        }

        engine.attach(good)
        engine.attach(warn)
        engine.connect(good, to: engine.mainMixerNode, format: format)
        engine.connect(warn, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 0.6
    }

    private func startIfNeeded() {
        configureIfNeeded()
        if !engine.isRunning {
            try? engine.start()
        }
    }

    /// Feed the current finger state. `distance` is the unit-space distance
    /// from where the finger should be (the stroke path, or its start dot);
    /// `tolerance` is the on-track threshold; `progressRatio` (0...1) drives
    /// the rising melody.
    func update(distance: CGFloat, tolerance: CGFloat, progressRatio: CGFloat) {
        guard enabled else { return }
        startIfNeeded()
        if distance <= tolerance {
            let index = max(0, min(scale.count - 1,
                                   Int(progressRatio * CGFloat(scale.count))))
            goodTargetFreq = scale[index]
            goodTargetAmp = 0.16
            warnTargetAmp = 0
        } else {
            // The farther off the line, the louder the wobble (capped),
            // fading back down as the finger returns — the "heat map".
            let excess = min(1, (distance - tolerance) / 0.3)
            goodTargetAmp = 0
            warnTargetAmp = 0.05 + 0.28 * Float(excess)
        }
    }

    func touchEnded() {
        goodTargetAmp = 0
        warnTargetAmp = 0
    }

    /// Bright rising chime when a stroke is completed.
    func strokeChime() {
        guard enabled else { return }
        startIfNeeded()
        warnTargetAmp = 0
        goodTargetFreq = scale[3]
        goodTargetAmp = 0.22
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.goodTargetFreq = self?.scale.last ?? 1046.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.goodTargetAmp = 0
        }
    }

    /// Fade out and pause the engine when leaving the tracing screen.
    func suspend() {
        goodTargetAmp = 0
        warnTargetAmp = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self, self.goodTargetAmp == 0, self.warnTargetAmp == 0 else { return }
            self.engine.pause()
        }
    }
}
