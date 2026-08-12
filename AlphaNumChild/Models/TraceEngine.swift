import Foundation
import CoreGraphics
import Combine

/// Drives one tracing exercise: validates finger movement against the
/// character's strokes in order, tracks progress, and plays the animated
/// pencil demonstration.
final class TraceEngine: ObservableObject {

    let character: TraceCharacter

    @Published private(set) var strokeIndex = 0
    @Published private(set) var progress: CGFloat = 0
    @Published private(set) var completed = false

    /// Non-nil while the pencil demonstration is running: distance traveled
    /// across the demo strokes.
    @Published private(set) var demoDistance: CGFloat?
    private(set) var demoBaseIndex = 0

    // Tolerances are generous on purpose: little fingers are wobbly.
    private let tolerance: CGFloat = 0.12
    private let startTolerance: CGFloat = 0.16
    private let maxAdvance: CGFloat = 0.17

    private var strokeStarted = false
    private var demoTimer: Timer?
    private let demoSpeed: CGFloat = 0.55   // unit lengths per second

    var onStrokeCompleted: (() -> Void)?
    var onCompleted: (() -> Void)?

    init(character: TraceCharacter) {
        self.character = character
    }

    deinit {
        demoTimer?.invalidate()
    }

    var strokes: [TraceStroke] { character.strokes }
    var currentStroke: TraceStroke? {
        strokeIndex < strokes.count ? strokes[strokeIndex] : nil
    }

    // MARK: - Tracing

    func touch(at p: CGPoint) {
        guard !completed, let stroke = currentStroke else { return }
        stopDemo()

        if stroke.isDot {
            if distance(p, stroke.center) < startTolerance {
                finishCurrentStroke()
            }
            return
        }

        if !strokeStarted {
            guard distance(p, stroke.start) < startTolerance else { return }
            strokeStarted = true
        }

        if let s = project(p, on: stroke,
                           windowStart: max(0, progress - 0.06),
                           windowEnd: progress + maxAdvance),
           s > progress {
            progress = s
        }

        if progress >= stroke.length - 0.035 {
            finishCurrentStroke()
        }
    }

    func touchEnded() {
        guard !completed, let stroke = currentStroke, strokeStarted else { return }
        // Forgiving finish: lifting the finger very near the end counts.
        let remaining = stroke.length - progress
        if remaining < max(0.1, stroke.length * 0.12) {
            finishCurrentStroke()
        }
    }

    func reset() {
        stopDemo()
        strokeIndex = 0
        progress = 0
        strokeStarted = false
        completed = false
    }

    private func finishCurrentStroke() {
        progress = 0
        strokeStarted = false
        strokeIndex += 1
        if strokeIndex >= strokes.count {
            completed = true
            onCompleted?()
        } else {
            onStrokeCompleted?()
        }
    }

    /// Closest-point projection of `p` onto the stroke, limited to a window
    /// of arc length so the child can't skip ahead or cut corners.
    /// Returns the arc-length position, or nil if the finger is off the path.
    private func project(_ p: CGPoint, on stroke: TraceStroke,
                         windowStart: CGFloat, windowEnd: CGFloat) -> CGFloat? {
        var best: (s: CGFloat, d: CGFloat)?
        let pts = stroke.points
        for i in 0..<(pts.count - 1) {
            let segStart = stroke.cumulativeLengths[i]
            let segEnd = stroke.cumulativeLengths[i + 1]
            let segLen = segEnd - segStart
            guard segLen > 0, segEnd >= windowStart, segStart <= windowEnd else { continue }

            let a = pts[i], b = pts[i + 1]
            let abx = b.x - a.x, aby = b.y - a.y
            var t = ((p.x - a.x) * abx + (p.y - a.y) * aby) / (segLen * segLen)
            let tMin = max(0, (windowStart - segStart) / segLen)
            let tMax = min(1, (windowEnd - segStart) / segLen)
            t = min(max(t, tMin), tMax)

            let q = CGPoint(x: a.x + abx * t, y: a.y + aby * t)
            let d = distance(p, q)
            if d <= tolerance, best == nil || d < best!.d {
                best = (segStart + segLen * t, d)
            }
        }
        return best?.s
    }

    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        hypot(a.x - b.x, a.y - b.y)
    }

    // MARK: - Pencil demonstration

    /// Total demo length across the strokes still to be traced.
    var demoTotalLength: CGFloat {
        strokes[demoBaseIndex...].reduce(0) { $0 + max($1.length, 0.08) }
    }

    /// How much demo ink covers a given stroke (0 if untouched).
    func demoInk(for index: Int) -> CGFloat {
        guard let d = demoDistance, index >= demoBaseIndex else { return 0 }
        var offset: CGFloat = 0
        for i in demoBaseIndex..<index {
            offset += max(strokes[i].length, 0.08)
        }
        return min(max(d - offset, 0), strokes[index].length)
    }

    /// Where the demo pencil currently is (unit space).
    var demoPencilPoint: CGPoint? {
        guard let d = demoDistance else { return nil }
        var offset: CGFloat = 0
        for i in demoBaseIndex..<strokes.count {
            let l = max(strokes[i].length, 0.08)
            if d <= offset + l {
                return strokes[i].point(at: d - offset)
            }
            offset += l
        }
        return strokes.last?.end
    }

    func startDemo() {
        guard !completed else { return }
        stopDemo()
        demoBaseIndex = strokeIndex
        demoDistance = 0
        let total = demoTotalLength
        demoTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0,
                                         repeats: true) { [weak self] _ in
            guard let self, let d = self.demoDistance else { return }
            let next = d + self.demoSpeed / 60.0
            if next >= total + 0.25 {
                self.stopDemo()
            } else {
                self.demoDistance = next
            }
        }
    }

    func stopDemo() {
        demoTimer?.invalidate()
        demoTimer = nil
        if demoDistance != nil {
            demoDistance = nil
        }
    }
}
