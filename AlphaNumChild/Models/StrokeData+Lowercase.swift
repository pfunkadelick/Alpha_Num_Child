import CoreGraphics

// Lowercase letters: ascenders start at y = 0.15, the x-height band runs
// from y = 0.42 to the baseline at y = 0.78, and descenders reach y = 0.97.
extension CharacterLibrary {

    static let lowercase: [TraceCharacter] = [
        TraceCharacter(id: "L-a", glyph: "a", spokenName: "little a", strokes: [
            PB.arc(c: (0.47, 0.6), r: 0.18, from: 30, to: 390),
            PB.poly((0.65, 0.42), (0.65, 0.78)),
        ]),
        TraceCharacter(id: "L-b", glyph: "b", spokenName: "little b", strokes: [
            PB.poly((0.32, 0.15), (0.32, 0.78)),
            PB.arc(c: (0.5, 0.6), r: 0.18, from: 180, to: -180),
        ]),
        TraceCharacter(id: "L-c", glyph: "c", spokenName: "little c", strokes: [
            PB.arc(c: (0.5, 0.6), r: 0.19, from: 50, to: 310),
        ]),
        TraceCharacter(id: "L-d", glyph: "d", spokenName: "little d", strokes: [
            PB.arc(c: (0.5, 0.6), r: 0.18, from: 30, to: 390),
            PB.poly((0.68, 0.15), (0.68, 0.78)),
        ]),
        TraceCharacter(id: "L-e", glyph: "e", spokenName: "little e", strokes: [
            PB.join(PB.poly((0.33, 0.62), (0.68, 0.62)),
                    PB.arc(c: (0.5, 0.61), rx: 0.185, ry: 0.19, from: 0, to: 305)),
        ]),
        TraceCharacter(id: "L-f", glyph: "f", spokenName: "little f", strokes: [
            PB.join(PB.arc(c: (0.6, 0.3), r: 0.15, from: 90, to: 180),
                    PB.poly((0.45, 0.3), (0.45, 0.78))),
            PB.poly((0.3, 0.45), (0.62, 0.45)),
        ]),
        TraceCharacter(id: "L-g", glyph: "g", spokenName: "little g", strokes: [
            PB.arc(c: (0.47, 0.6), r: 0.18, from: 30, to: 390),
            PB.join(PB.poly((0.65, 0.42), (0.65, 0.82)),
                    PB.arc(c: (0.5, 0.82), r: 0.15, from: 0, to: -180)),
        ]),
        TraceCharacter(id: "L-h", glyph: "h", spokenName: "little h", strokes: [
            PB.poly((0.32, 0.15), (0.32, 0.78)),
            PB.join(PB.arc(c: (0.5, 0.6), r: 0.18, from: 180, to: 0),
                    PB.poly((0.68, 0.6), (0.68, 0.78))),
        ]),
        TraceCharacter(id: "L-i", glyph: "i", spokenName: "little i", traceStrokes: [
            TraceStroke(PB.poly((0.5, 0.42), (0.5, 0.78))),
            TraceStroke.dot(0.5, 0.27),
        ]),
        TraceCharacter(id: "L-j", glyph: "j", spokenName: "little j", traceStrokes: [
            TraceStroke(PB.join(PB.poly((0.58, 0.42), (0.58, 0.82)),
                                PB.arc(c: (0.43, 0.82), r: 0.15, from: 0, to: -180))),
            TraceStroke.dot(0.58, 0.27),
        ]),
        TraceCharacter(id: "L-k", glyph: "k", spokenName: "little k", strokes: [
            PB.poly((0.32, 0.15), (0.32, 0.78)),
            PB.poly((0.62, 0.45), (0.32, 0.62)),
            PB.poly((0.32, 0.62), (0.64, 0.78)),
        ]),
        TraceCharacter(id: "L-l", glyph: "l", spokenName: "little l", strokes: [
            PB.poly((0.5, 0.15), (0.5, 0.78)),
        ]),
        TraceCharacter(id: "L-m", glyph: "m", spokenName: "little m", strokes: [
            PB.poly((0.28, 0.42), (0.28, 0.78)),
            PB.join(PB.arc(c: (0.39, 0.55), rx: 0.11, ry: 0.13, from: 180, to: 0),
                    PB.poly((0.5, 0.55), (0.5, 0.78))),
            PB.join(PB.arc(c: (0.61, 0.55), rx: 0.11, ry: 0.13, from: 180, to: 0),
                    PB.poly((0.72, 0.55), (0.72, 0.78))),
        ]),
        TraceCharacter(id: "L-n", glyph: "n", spokenName: "little n", strokes: [
            PB.poly((0.32, 0.42), (0.32, 0.78)),
            PB.join(PB.arc(c: (0.5, 0.6), r: 0.18, from: 180, to: 0),
                    PB.poly((0.68, 0.6), (0.68, 0.78))),
        ]),
        TraceCharacter(id: "L-o", glyph: "o", spokenName: "little o", strokes: [
            PB.arc(c: (0.5, 0.6), r: 0.19, from: 90, to: 450),
        ]),
        TraceCharacter(id: "L-p", glyph: "p", spokenName: "little p", strokes: [
            PB.poly((0.34, 0.42), (0.34, 0.97)),
            PB.arc(c: (0.52, 0.6), r: 0.18, from: 180, to: -180),
        ]),
        TraceCharacter(id: "L-q", glyph: "q", spokenName: "little q", strokes: [
            PB.arc(c: (0.48, 0.6), r: 0.18, from: 30, to: 390),
            PB.poly((0.66, 0.42), (0.66, 0.95), (0.76, 0.88)),
        ]),
        TraceCharacter(id: "L-r", glyph: "r", spokenName: "little r", strokes: [
            PB.poly((0.36, 0.42), (0.36, 0.78)),
            PB.arc(c: (0.52, 0.58), r: 0.16, from: 180, to: 30),
        ]),
        TraceCharacter(id: "L-s", glyph: "s", spokenName: "little s", strokes: [
            PB.join(PB.arc(c: (0.5, 0.51), rx: 0.13, ry: 0.09, from: 45, to: 270),
                    PB.arc(c: (0.5, 0.69), rx: 0.14, ry: 0.09, from: 90, to: -135)),
        ]),
        TraceCharacter(id: "L-t", glyph: "t", spokenName: "little t", strokes: [
            PB.join(PB.poly((0.5, 0.2), (0.5, 0.66)),
                    PB.arc(c: (0.62, 0.66), r: 0.12, from: 180, to: 270)),
            PB.poly((0.34, 0.42), (0.68, 0.42)),
        ]),
        TraceCharacter(id: "L-u", glyph: "u", spokenName: "little u", strokes: [
            PB.join(PB.poly((0.33, 0.42), (0.33, 0.61)),
                    PB.arc(c: (0.5, 0.61), r: 0.17, from: 180, to: 360),
                    PB.poly((0.67, 0.61), (0.67, 0.42))),
            PB.poly((0.67, 0.42), (0.67, 0.78)),
        ]),
        TraceCharacter(id: "L-v", glyph: "v", spokenName: "little v", strokes: [
            PB.poly((0.32, 0.42), (0.5, 0.78), (0.68, 0.42)),
        ]),
        TraceCharacter(id: "L-w", glyph: "w", spokenName: "little w", strokes: [
            PB.poly((0.26, 0.42), (0.38, 0.78), (0.5, 0.48), (0.62, 0.78), (0.74, 0.42)),
        ]),
        TraceCharacter(id: "L-x", glyph: "x", spokenName: "little x", strokes: [
            PB.poly((0.34, 0.42), (0.66, 0.78)),
            PB.poly((0.66, 0.42), (0.34, 0.78)),
        ]),
        TraceCharacter(id: "L-y", glyph: "y", spokenName: "little y", strokes: [
            PB.poly((0.32, 0.42), (0.5, 0.78)),
            PB.poly((0.68, 0.42), (0.38, 0.97)),
        ]),
        TraceCharacter(id: "L-z", glyph: "z", spokenName: "little z", strokes: [
            PB.poly((0.34, 0.42), (0.66, 0.42), (0.34, 0.78), (0.66, 0.78)),
        ]),
    ]
}
