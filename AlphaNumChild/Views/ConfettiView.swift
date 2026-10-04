import SwiftUI

/// Lightweight falling-confetti animation used during celebrations.
struct ConfettiView: View {
    private let start = Date()
    private let pieceCount = 60
    private let duration: TimeInterval = 3.5

    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSince(start)
                guard t < duration else { return }

                for i in 0..<pieceCount {
                    // Deterministic pseudo-random values per piece.
                    let r1 = pseudoRandom(i, 1)
                    let r2 = pseudoRandom(i, 2)
                    let r3 = pseudoRandom(i, 3)
                    let r4 = pseudoRandom(i, 4)

                    let delay = r4 * 0.8
                    let tt = t - delay
                    guard tt > 0 else { continue }

                    let x = r1 * size.width + sin(tt * (2 + r2 * 3)) * 30
                    let speed = 120 + r2 * 180
                    let y = -20 + tt * speed
                    guard y < size.height + 20 else { continue }

                    let rotation = Angle(radians: tt * (2 + r3 * 5))
                    let pieceSize = 6 + r3 * 8

                    var piece = ctx
                    piece.translateBy(x: x, y: y)
                    piece.rotate(by: rotation)
                    piece.opacity = min(1, (duration - t) / 0.6)
                    piece.fill(
                        Path(roundedRect: CGRect(x: -pieceSize / 2, y: -pieceSize / 3,
                                                 width: pieceSize, height: pieceSize * 0.66),
                             cornerRadius: 2),
                        with: .color(colors[i % colors.count])
                    )
                }
            }
        }
    }

    private func pseudoRandom(_ i: Int, _ salt: Int) -> Double {
        let v = sin(Double(i * 127 + salt * 311) * 12.9898) * 43758.5453
        return v - v.rounded(.down)
    }
}
