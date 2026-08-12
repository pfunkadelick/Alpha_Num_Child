import CoreGraphics
import SwiftUI

/// One stroke of a character, in the unit square (y down).
struct TraceStroke {
    let points: [CGPoint]
    let isDot: Bool
    let cumulativeLengths: [CGFloat]
    let length: CGFloat

    init(_ points: [CGPoint], isDot: Bool = false) {
        self.points = points
        self.isDot = isDot
        var cum: [CGFloat] = [0]
        cum.reserveCapacity(points.count)
        for i in 1..<max(points.count, 1) {
            cum.append(cum[i - 1] + hypot(points[i].x - points[i - 1].x,
                                          points[i].y - points[i - 1].y))
        }
        self.cumulativeLengths = cum
        self.length = cum.last ?? 0
    }

    /// A tap-to-complete dot (for i and j).
    static func dot(_ x: CGFloat, _ y: CGFloat) -> TraceStroke {
        TraceStroke(PB.arc(c: (x, y), r: 0.022, from: 90, to: 450), isDot: true)
    }

    var start: CGPoint { points.first ?? .zero }
    var end: CGPoint { points.last ?? .zero }

    var center: CGPoint {
        guard !points.isEmpty else { return .zero }
        let sx = points.reduce(CGFloat(0)) { $0 + $1.x }
        let sy = points.reduce(CGFloat(0)) { $0 + $1.y }
        return CGPoint(x: sx / CGFloat(points.count), y: sy / CGFloat(points.count))
    }

    /// Point at a given arc-length distance along the stroke.
    func point(at distance: CGFloat) -> CGPoint {
        guard points.count > 1 else { return start }
        let d = min(max(distance, 0), length)
        for i in 1..<points.count where cumulativeLengths[i] >= d {
            let segLen = cumulativeLengths[i] - cumulativeLengths[i - 1]
            guard segLen > 0 else { return points[i] }
            let t = (d - cumulativeLengths[i - 1]) / segLen
            let a = points[i - 1], b = points[i]
            return CGPoint(x: a.x + (b.x - a.x) * t, y: a.y + (b.y - a.y) * t)
        }
        return end
    }

    /// SwiftUI path for the stroke (optionally truncated), mapped into `rect`.
    func path(upTo distance: CGFloat? = nil, in rect: CGRect) -> Path {
        var p = Path()
        guard points.count > 1 else { return p }
        func map(_ pt: CGPoint) -> CGPoint {
            CGPoint(x: rect.minX + pt.x * rect.width,
                    y: rect.minY + pt.y * rect.height)
        }
        p.move(to: map(points[0]))
        if let d = distance {
            guard d > 0.001 else { return p }
            for i in 1..<points.count {
                if cumulativeLengths[i] <= d {
                    p.addLine(to: map(points[i]))
                } else {
                    p.addLine(to: map(point(at: d)))
                    break
                }
            }
        } else {
            for i in 1..<points.count {
                p.addLine(to: map(points[i]))
            }
        }
        return p
    }
}

/// A traceable character: a letter or number with ordered strokes.
struct TraceCharacter: Identifiable, Hashable {
    let id: String
    let glyph: String
    let spokenName: String
    let strokes: [TraceStroke]

    init(id: String, glyph: String, spokenName: String, strokes: [[CGPoint]]) {
        self.id = id
        self.glyph = glyph
        self.spokenName = spokenName
        self.strokes = strokes.map { TraceStroke($0) }
    }

    init(id: String, glyph: String, spokenName: String, traceStrokes: [TraceStroke]) {
        self.id = id
        self.glyph = glyph
        self.spokenName = spokenName
        self.strokes = traceStrokes
    }

    static func == (lhs: TraceCharacter, rhs: TraceCharacter) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// The three learning categories plus their look and handwriting guide lines.
enum TraceCategory: String, CaseIterable, Identifiable {
    case uppercase
    case lowercase
    case numbers

    var id: String { rawValue }

    var title: String {
        switch self {
        case .uppercase: return "Big Letters"
        case .lowercase: return "Small Letters"
        case .numbers: return "Numbers"
        }
    }

    var badge: String {
        switch self {
        case .uppercase: return "ABC"
        case .lowercase: return "abc"
        case .numbers: return "123"
        }
    }

    var characters: [TraceCharacter] {
        switch self {
        case .uppercase: return CharacterLibrary.uppercase
        case .lowercase: return CharacterLibrary.lowercase
        case .numbers: return CharacterLibrary.numbers
        }
    }

    /// Horizontal handwriting guide lines (unit-space y positions).
    /// The middle value is drawn dashed, like handwriting paper.
    var guideLines: [CGFloat] {
        switch self {
        case .uppercase, .numbers: return [0.15, 0.5, 0.85]
        case .lowercase: return [0.15, 0.42, 0.78]
        }
    }

    var gradient: [Color] {
        switch self {
        case .uppercase: return [Color(red: 1.0, green: 0.45, blue: 0.42),
                                 Color(red: 1.0, green: 0.62, blue: 0.29)]
        case .lowercase: return [Color(red: 0.29, green: 0.72, blue: 0.47),
                                 Color(red: 0.16, green: 0.62, blue: 0.74)]
        case .numbers: return [Color(red: 0.42, green: 0.5, blue: 0.95),
                               Color(red: 0.66, green: 0.42, blue: 0.94)]
        }
    }
}
