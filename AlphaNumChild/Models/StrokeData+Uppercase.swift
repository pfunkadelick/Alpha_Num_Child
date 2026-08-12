import CoreGraphics

// Uppercase letters live between y = 0.15 (top line) and y = 0.85 (baseline).
// Stroke order follows common US handwriting instruction (top-to-bottom,
// left-to-right).
extension CharacterLibrary {

    static let uppercase: [TraceCharacter] = [
        TraceCharacter(id: "U-A", glyph: "A", spokenName: "A", strokes: [
            PB.poly((0.5, 0.15), (0.22, 0.85)),
            PB.poly((0.5, 0.15), (0.78, 0.85)),
            PB.poly((0.32, 0.6), (0.68, 0.6)),
        ]),
        TraceCharacter(id: "U-B", glyph: "B", spokenName: "B", strokes: [
            PB.poly((0.28, 0.15), (0.28, 0.85)),
            PB.join(PB.poly((0.28, 0.15), (0.5, 0.15)),
                    PB.arc(c: (0.5, 0.325), r: 0.175, from: 90, to: -90),
                    PB.poly((0.5, 0.5), (0.28, 0.5)),
                    PB.poly((0.28, 0.5), (0.52, 0.5)),
                    PB.arc(c: (0.52, 0.675), r: 0.175, from: 90, to: -90),
                    PB.poly((0.52, 0.85), (0.28, 0.85))),
        ]),
        TraceCharacter(id: "U-C", glyph: "C", spokenName: "C", strokes: [
            PB.arc(c: (0.5, 0.5), rx: 0.3, ry: 0.35, from: 55, to: 305),
        ]),
        TraceCharacter(id: "U-D", glyph: "D", spokenName: "D", strokes: [
            PB.poly((0.28, 0.15), (0.28, 0.85)),
            PB.join(PB.poly((0.28, 0.15), (0.42, 0.15)),
                    PB.arc(c: (0.42, 0.5), r: 0.35, from: 90, to: -90),
                    PB.poly((0.42, 0.85), (0.28, 0.85))),
        ]),
        TraceCharacter(id: "U-E", glyph: "E", spokenName: "E", strokes: [
            PB.poly((0.28, 0.15), (0.28, 0.85)),
            PB.poly((0.28, 0.15), (0.75, 0.15)),
            PB.poly((0.28, 0.5), (0.68, 0.5)),
            PB.poly((0.28, 0.85), (0.75, 0.85)),
        ]),
        TraceCharacter(id: "U-F", glyph: "F", spokenName: "F", strokes: [
            PB.poly((0.28, 0.15), (0.28, 0.85)),
            PB.poly((0.28, 0.15), (0.75, 0.15)),
            PB.poly((0.28, 0.5), (0.66, 0.5)),
        ]),
        TraceCharacter(id: "U-G", glyph: "G", spokenName: "G", strokes: [
            PB.arc(c: (0.5, 0.5), rx: 0.32, ry: 0.35, from: 55, to: 338),
            PB.poly((0.5, 0.62), (0.8, 0.62)),
        ]),
        TraceCharacter(id: "U-H", glyph: "H", spokenName: "H", strokes: [
            PB.poly((0.25, 0.15), (0.25, 0.85)),
            PB.poly((0.75, 0.15), (0.75, 0.85)),
            PB.poly((0.25, 0.5), (0.75, 0.5)),
        ]),
        TraceCharacter(id: "U-I", glyph: "I", spokenName: "I", strokes: [
            PB.poly((0.5, 0.15), (0.5, 0.85)),
            PB.poly((0.32, 0.15), (0.68, 0.15)),
            PB.poly((0.32, 0.85), (0.68, 0.85)),
        ]),
        TraceCharacter(id: "U-J", glyph: "J", spokenName: "J", strokes: [
            PB.join(PB.poly((0.62, 0.15), (0.62, 0.68)),
                    PB.arc(c: (0.47, 0.68), rx: 0.15, ry: 0.17, from: 0, to: -180)),
            PB.poly((0.42, 0.15), (0.82, 0.15)),
        ]),
        TraceCharacter(id: "U-K", glyph: "K", spokenName: "K", strokes: [
            PB.poly((0.28, 0.15), (0.28, 0.85)),
            PB.poly((0.72, 0.15), (0.28, 0.52)),
            PB.poly((0.28, 0.52), (0.72, 0.85)),
        ]),
        TraceCharacter(id: "U-L", glyph: "L", spokenName: "L", strokes: [
            PB.poly((0.3, 0.15), (0.3, 0.85), (0.74, 0.85)),
        ]),
        TraceCharacter(id: "U-M", glyph: "M", spokenName: "M", strokes: [
            PB.poly((0.2, 0.15), (0.2, 0.85)),
            PB.poly((0.2, 0.15), (0.5, 0.72), (0.8, 0.15)),
            PB.poly((0.8, 0.15), (0.8, 0.85)),
        ]),
        TraceCharacter(id: "U-N", glyph: "N", spokenName: "N", strokes: [
            PB.poly((0.26, 0.15), (0.26, 0.85)),
            PB.poly((0.26, 0.15), (0.74, 0.85)),
            PB.poly((0.74, 0.85), (0.74, 0.15)),
        ]),
        TraceCharacter(id: "U-O", glyph: "O", spokenName: "O", strokes: [
            PB.arc(c: (0.5, 0.5), rx: 0.3, ry: 0.35, from: 90, to: 450),
        ]),
        TraceCharacter(id: "U-P", glyph: "P", spokenName: "P", strokes: [
            PB.poly((0.28, 0.15), (0.28, 0.85)),
            PB.join(PB.poly((0.28, 0.15), (0.5, 0.15)),
                    PB.arc(c: (0.5, 0.33), r: 0.18, from: 90, to: -90),
                    PB.poly((0.5, 0.51), (0.28, 0.51))),
        ]),
        TraceCharacter(id: "U-Q", glyph: "Q", spokenName: "Q", strokes: [
            PB.arc(c: (0.5, 0.5), rx: 0.3, ry: 0.35, from: 90, to: 450),
            PB.poly((0.58, 0.62), (0.84, 0.88)),
        ]),
        TraceCharacter(id: "U-R", glyph: "R", spokenName: "R", strokes: [
            PB.poly((0.28, 0.15), (0.28, 0.85)),
            PB.join(PB.poly((0.28, 0.15), (0.5, 0.15)),
                    PB.arc(c: (0.5, 0.33), r: 0.18, from: 90, to: -90),
                    PB.poly((0.5, 0.51), (0.28, 0.51))),
            PB.poly((0.34, 0.51), (0.74, 0.85)),
        ]),
        TraceCharacter(id: "U-S", glyph: "S", spokenName: "S", strokes: [
            PB.join(PB.arc(c: (0.5, 0.33), rx: 0.21, ry: 0.18, from: 45, to: 270),
                    PB.arc(c: (0.5, 0.67), rx: 0.22, ry: 0.18, from: 90, to: -135)),
        ]),
        TraceCharacter(id: "U-T", glyph: "T", spokenName: "T", strokes: [
            PB.poly((0.5, 0.15), (0.5, 0.85)),
            PB.poly((0.2, 0.15), (0.8, 0.15)),
        ]),
        TraceCharacter(id: "U-U", glyph: "U", spokenName: "U", strokes: [
            PB.join(PB.poly((0.26, 0.15), (0.26, 0.58)),
                    PB.arc(c: (0.5, 0.58), rx: 0.24, ry: 0.27, from: 180, to: 360),
                    PB.poly((0.74, 0.58), (0.74, 0.15))),
        ]),
        TraceCharacter(id: "U-V", glyph: "V", spokenName: "V", strokes: [
            PB.poly((0.22, 0.15), (0.5, 0.85), (0.78, 0.15)),
        ]),
        TraceCharacter(id: "U-W", glyph: "W", spokenName: "W", strokes: [
            PB.poly((0.16, 0.15), (0.34, 0.85), (0.5, 0.4), (0.66, 0.85), (0.84, 0.15)),
        ]),
        TraceCharacter(id: "U-X", glyph: "X", spokenName: "X", strokes: [
            PB.poly((0.25, 0.15), (0.75, 0.85)),
            PB.poly((0.75, 0.15), (0.25, 0.85)),
        ]),
        TraceCharacter(id: "U-Y", glyph: "Y", spokenName: "Y", strokes: [
            PB.poly((0.24, 0.15), (0.5, 0.5)),
            PB.poly((0.76, 0.15), (0.5, 0.5)),
            PB.poly((0.5, 0.5), (0.5, 0.85)),
        ]),
        TraceCharacter(id: "U-Z", glyph: "Z", spokenName: "Z", strokes: [
            PB.poly((0.24, 0.15), (0.76, 0.15), (0.24, 0.85), (0.76, 0.85)),
        ]),
    ]
}
