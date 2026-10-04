import CoreGraphics

/// Helpers for authoring stroke paths in a normalized 0...1 coordinate
/// space (x right, y down). Arc angles use "visual" degrees: 0 = right,
/// 90 = up on screen, measured counter-clockwise as a person sees it.
enum PB {

    static func poly(_ pts: (CGFloat, CGFloat)...) -> [CGPoint] {
        pts.map { CGPoint(x: $0.0, y: $0.1) }
    }

    static func arc(c: (CGFloat, CGFloat),
                    rx: CGFloat, ry: CGFloat,
                    from a0: CGFloat, to a1: CGFloat) -> [CGPoint] {
        let steps = max(3, Int(abs(a1 - a0) / 5))
        return (0...steps).map { i in
            let a = (a0 + (a1 - a0) * CGFloat(i) / CGFloat(steps)) * .pi / 180
            return CGPoint(x: c.0 + rx * cos(a), y: c.1 - ry * sin(a))
        }
    }

    static func arc(c: (CGFloat, CGFloat), r: CGFloat,
                    from a0: CGFloat, to a1: CGFloat) -> [CGPoint] {
        arc(c: c, rx: r, ry: r, from: a0, to: a1)
    }

    static func quad(_ p0: (CGFloat, CGFloat),
                     _ cp: (CGFloat, CGFloat),
                     _ p1: (CGFloat, CGFloat)) -> [CGPoint] {
        (0...16).map { i in
            let t = CGFloat(i) / 16
            let m = 1 - t
            return CGPoint(x: m * m * p0.0 + 2 * m * t * cp.0 + t * t * p1.0,
                           y: m * m * p0.1 + 2 * m * t * cp.1 + t * t * p1.1)
        }
    }

    /// Concatenate path pieces into one stroke, dropping duplicated
    /// junction points where pieces meet.
    static func join(_ parts: [CGPoint]...) -> [CGPoint] {
        var out: [CGPoint] = []
        for part in parts {
            for p in part {
                if let last = out.last,
                   abs(last.x - p.x) < 0.006, abs(last.y - p.y) < 0.006 {
                    continue
                }
                out.append(p)
            }
        }
        return out
    }
}
