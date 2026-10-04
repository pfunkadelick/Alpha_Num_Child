import CoreGraphics

/// Namespace for all built-in traceable characters.
enum CharacterLibrary {}

// Numbers use the same band as uppercase letters: y = 0.15 to y = 0.85.
extension CharacterLibrary {

    static let numbers: [TraceCharacter] = [
        TraceCharacter(id: "N-0", glyph: "0", spokenName: "zero", strokes: [
            PB.arc(c: (0.5, 0.5), rx: 0.24, ry: 0.35, from: 90, to: 450),
        ]),
        TraceCharacter(id: "N-1", glyph: "1", spokenName: "one", strokes: [
            PB.poly((0.36, 0.3), (0.52, 0.15), (0.52, 0.85)),
        ]),
        TraceCharacter(id: "N-2", glyph: "2", spokenName: "two", strokes: [
            PB.join(PB.arc(c: (0.5, 0.34), rx: 0.21, ry: 0.19, from: 160, to: -35),
                    PB.poly((0.67, 0.45), (0.27, 0.85), (0.76, 0.85))),
        ]),
        TraceCharacter(id: "N-3", glyph: "3", spokenName: "three", strokes: [
            PB.join(PB.arc(c: (0.5, 0.325), rx: 0.19, ry: 0.175, from: 140, to: -90),
                    PB.arc(c: (0.5, 0.675), rx: 0.21, ry: 0.175, from: 90, to: -140)),
        ]),
        TraceCharacter(id: "N-4", glyph: "4", spokenName: "four", strokes: [
            PB.poly((0.55, 0.15), (0.22, 0.62), (0.8, 0.62)),
            PB.poly((0.66, 0.15), (0.66, 0.85)),
        ]),
        TraceCharacter(id: "N-5", glyph: "5", spokenName: "five", strokes: [
            PB.join(PB.poly((0.36, 0.15), (0.34, 0.42)),
                    PB.arc(c: (0.47, 0.63), rx: 0.24, ry: 0.22, from: 120, to: -150)),
            PB.poly((0.36, 0.15), (0.74, 0.15)),
        ]),
        TraceCharacter(id: "N-6", glyph: "6", spokenName: "six", strokes: [
            PB.join(PB.quad((0.66, 0.15), (0.44, 0.28), (0.34, 0.55)),
                    PB.arc(c: (0.52, 0.64), rx: 0.2, ry: 0.21, from: 155, to: 515)),
        ]),
        TraceCharacter(id: "N-7", glyph: "7", spokenName: "seven", strokes: [
            PB.poly((0.24, 0.15), (0.76, 0.15), (0.42, 0.85)),
        ]),
        TraceCharacter(id: "N-8", glyph: "8", spokenName: "eight", strokes: [
            PB.join(PB.arc(c: (0.5, 0.32), rx: 0.19, ry: 0.17, from: 45, to: 270),
                    PB.arc(c: (0.5, 0.66), rx: 0.21, ry: 0.19, from: 90, to: -270),
                    PB.arc(c: (0.5, 0.32), rx: 0.19, ry: 0.17, from: 270, to: 405)),
        ]),
        TraceCharacter(id: "N-9", glyph: "9", spokenName: "nine", strokes: [
            PB.join(PB.arc(c: (0.5, 0.35), rx: 0.19, ry: 0.2, from: 0, to: 360),
                    PB.poly((0.69, 0.35), (0.66, 0.85))),
        ]),
    ]
}
