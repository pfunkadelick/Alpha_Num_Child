import SwiftUI

/// The tracing surface: handwriting guide lines, the gray letter "track",
/// colored ink for traced strokes, numbered start bubbles, and the demo
/// pencil.
struct TracingCanvasView: View {
    @ObservedObject var engine: TraceEngine
    let category: TraceCategory

    private let crayons: [Color] = [
        Color(red: 0.95, green: 0.33, blue: 0.32),
        Color(red: 0.3, green: 0.55, blue: 0.95),
        Color(red: 0.29, green: 0.72, blue: 0.47),
        Color(red: 0.98, green: 0.6, blue: 0.2),
        Color(red: 0.66, green: 0.42, blue: 0.94),
        Color(red: 0.94, green: 0.45, blue: 0.65),
    ]

    var body: some View {
        GeometryReader { geo in
            let rect = Self.letterRect(in: geo.size)

            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)

                canvas(rect: rect)

                startBubbles(rect: rect)

                if let pencil = engine.demoPencilPoint {
                    let pencilScale = max(engine.character.toleranceFactor, 0.6)
                    Text("✏️")
                        .font(.system(size: rect.width * 0.16 * pencilScale))
                        .position(x: rect.minX + pencil.x * rect.width + rect.width * 0.05 * pencilScale,
                                  y: rect.minY + pencil.y * rect.height - rect.height * 0.05 * pencilScale)
                        .allowsHitTesting(false)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        engine.touch(at: unitPoint(value.location, in: rect))
                    }
                    .onEnded { _ in
                        engine.touchEnded()
                    }
            )
        }
    }

    /// Scales stroke thicknesses down for words, whose letters are smaller.
    private var f: CGFloat { engine.character.toleranceFactor }

    private func canvas(rect: CGRect) -> some View {
        Canvas { ctx, _ in
            drawGuideLines(ctx, rect: rect)

            let trackWidth = rect.width * 0.13 * f
            let inkWidth = rect.width * 0.105 * f

            // Gray track for every stroke.
            for stroke in engine.strokes {
                if stroke.isDot {
                    ctx.fill(dotPath(stroke, rect: rect, radius: trackWidth * 0.45),
                             with: .color(Color(.systemGray4)))
                } else {
                    ctx.stroke(stroke.path(in: rect),
                               with: .color(Color(.systemGray4)),
                               style: StrokeStyle(lineWidth: trackWidth,
                                                  lineCap: .round, lineJoin: .round))
                }
            }

            // Dashed white center guide inside the track.
            for stroke in engine.strokes where !stroke.isDot {
                ctx.stroke(stroke.path(in: rect),
                           with: .color(.white.opacity(0.9)),
                           style: StrokeStyle(lineWidth: rect.width * 0.008,
                                              lineCap: .round,
                                              dash: [rect.width * 0.02, rect.width * 0.035]))
            }

            // Demo ink (light blue) ahead of the child's progress.
            if engine.demoDistance != nil {
                for i in engine.demoBaseIndex..<engine.strokes.count {
                    let covered = engine.demoInk(for: i)
                    guard covered > 0 else { continue }
                    let stroke = engine.strokes[i]
                    if stroke.isDot {
                        ctx.fill(dotPath(stroke, rect: rect, radius: inkWidth * 0.45),
                                 with: .color(.blue.opacity(0.3)))
                    } else {
                        ctx.stroke(stroke.path(upTo: covered, in: rect),
                                   with: .color(.blue.opacity(0.3)),
                                   style: StrokeStyle(lineWidth: inkWidth,
                                                      lineCap: .round, lineJoin: .round))
                    }
                }
            }

            // Ink for finished strokes.
            for i in 0..<engine.strokeIndex where i < engine.strokes.count {
                let stroke = engine.strokes[i]
                let color = crayons[i % crayons.count]
                if stroke.isDot {
                    ctx.fill(dotPath(stroke, rect: rect, radius: inkWidth * 0.45),
                             with: .color(color))
                } else {
                    ctx.stroke(stroke.path(in: rect),
                               with: .color(color),
                               style: StrokeStyle(lineWidth: inkWidth,
                                                  lineCap: .round, lineJoin: .round))
                }
            }

            // Ink for the stroke in progress.
            if !engine.completed, engine.progress > 0,
               let stroke = engine.currentStroke, !stroke.isDot {
                ctx.stroke(stroke.path(upTo: engine.progress, in: rect),
                           with: .color(crayons[engine.strokeIndex % crayons.count]),
                           style: StrokeStyle(lineWidth: inkWidth,
                                              lineCap: .round, lineJoin: .round))
            }

            // Direction chevrons along the rest of the current stroke.
            if !engine.completed, let stroke = engine.currentStroke, !stroke.isDot {
                drawChevrons(ctx, stroke: stroke, from: engine.progress, rect: rect)
            }
        }
    }

    /// Small arrowheads spaced along the untraced part of the stroke,
    /// pointing in the direction the finger should travel.
    private func drawChevrons(_ ctx: GraphicsContext, stroke: TraceStroke,
                              from progress: CGFloat, rect: CGRect) {
        let spacing: CGFloat = 0.11 * f
        let size = rect.width * 0.022 * f
        var d = max(progress, 0) + 0.08 * f
        while d < stroke.length - 0.03 {
            let p = stroke.point(at: d)
            let ahead = stroke.point(at: min(d + 0.02, stroke.length))
            let behind = stroke.point(at: max(d - 0.02, 0))
            let dx = ahead.x - behind.x, dy = ahead.y - behind.y
            let len = max(sqrt(dx * dx + dy * dy), 0.0001)
            let tx = dx / len, ty = dy / len          // tangent
            let nx = -ty, ny = tx                     // normal

            let center = CGPoint(x: rect.minX + p.x * rect.width,
                                 y: rect.minY + p.y * rect.height)
            let tip = CGPoint(x: center.x + tx * size, y: center.y + ty * size)
            let left = CGPoint(x: center.x - tx * size * 0.4 + nx * size,
                               y: center.y - ty * size * 0.4 + ny * size)
            let right = CGPoint(x: center.x - tx * size * 0.4 - nx * size,
                                y: center.y - ty * size * 0.4 - ny * size)

            var path = Path()
            path.move(to: left)
            path.addLine(to: tip)
            path.addLine(to: right)
            ctx.stroke(path,
                       with: .color(Color(red: 0.45, green: 0.6, blue: 0.78).opacity(0.9)),
                       style: StrokeStyle(lineWidth: rect.width * 0.012 * f,
                                          lineCap: .round, lineJoin: .round))
            d += spacing
        }
    }

    private func drawGuideLines(_ ctx: GraphicsContext, rect: CGRect) {
        let lineColor = Color(red: 0.6, green: 0.75, blue: 0.9)
        let guides = engine.character.guideLines ?? category.guideLines
        for (i, y) in guides.enumerated() {
            var p = Path()
            let yy = rect.minY + y * rect.height
            p.move(to: CGPoint(x: rect.minX - rect.width * 0.04, y: yy))
            p.addLine(to: CGPoint(x: rect.maxX + rect.width * 0.04, y: yy))
            let isMiddle = i == 1
            ctx.stroke(p,
                       with: .color(lineColor.opacity(isMiddle ? 0.5 : 0.7)),
                       style: StrokeStyle(lineWidth: 1.5,
                                          dash: isMiddle ? [6, 6] : []))
        }
    }

    private func dotPath(_ stroke: TraceStroke, rect: CGRect, radius: CGFloat) -> Path {
        let c = stroke.center
        let center = CGPoint(x: rect.minX + c.x * rect.width,
                             y: rect.minY + c.y * rect.height)
        return Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius,
                                      width: radius * 2, height: radius * 2))
    }

    /// Numbered bubbles marking where each remaining stroke begins;
    /// the current one pulses green.
    private func startBubbles(rect: CGRect) -> some View {
        ForEach(Array(engine.strokes.enumerated()), id: \.offset) { i, stroke in
            if !engine.completed, i >= engine.strokeIndex {
                let isCurrent = i == engine.strokeIndex
                let anchor = stroke.isDot ? stroke.center : stroke.start
                let bubbleScale = max(engine.character.toleranceFactor, 0.55)
                StartBubble(number: i + 1, isCurrent: isCurrent,
                            size: rect.width * (isCurrent ? 0.09 : 0.07) * bubbleScale)
                    .position(x: rect.minX + anchor.x * rect.width,
                              y: rect.minY + anchor.y * rect.height)
                    .allowsHitTesting(false)
            }
        }
    }

    private func unitPoint(_ p: CGPoint, in rect: CGRect) -> CGPoint {
        CGPoint(x: (p.x - rect.minX) / rect.width,
                y: (p.y - rect.minY) / rect.height)
    }

    /// Square letter area centered in the available space, with padding.
    static func letterRect(in size: CGSize) -> CGRect {
        let side = min(size.width, size.height) * 0.82
        return CGRect(x: (size.width - side) / 2,
                      y: (size.height - side) / 2,
                      width: side, height: side)
    }
}

private struct StartBubble: View {
    let number: Int
    let isCurrent: Bool
    let size: CGFloat

    @State private var pulsing = false

    var body: some View {
        ZStack {
            Circle()
                .fill(isCurrent ? Color(red: 0.29, green: 0.72, blue: 0.47) : Color(.systemGray3))
            Text("\(number)")
                .font(.system(size: size * 0.55, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
        .scaleEffect(isCurrent && pulsing ? 1.25 : 1.0)
        .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
        .onAppear { startPulseIfNeeded() }
        .onChange(of: isCurrent) { _ in startPulseIfNeeded() }
    }

    private func startPulseIfNeeded() {
        guard isCurrent, !pulsing else { return }
        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
            pulsing = true
        }
    }
}
