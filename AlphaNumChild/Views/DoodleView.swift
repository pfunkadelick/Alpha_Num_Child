import SwiftUI

/// Free-drawing scribble pad with a crayon palette.
struct DoodleView: View {
    private struct DoodlePath: Identifiable {
        let id = UUID()
        let color: Color
        let width: CGFloat
        var points: [CGPoint]
    }

    private let palette: [Color] = [
        Color(red: 0.95, green: 0.33, blue: 0.32),
        Color(red: 0.98, green: 0.6, blue: 0.2),
        Color(red: 0.99, green: 0.8, blue: 0.2),
        Color(red: 0.29, green: 0.72, blue: 0.47),
        Color(red: 0.3, green: 0.55, blue: 0.95),
        Color(red: 0.66, green: 0.42, blue: 0.94),
        Color(red: 0.94, green: 0.45, blue: 0.65),
        Color(red: 0.35, green: 0.25, blue: 0.2),
    ]

    @State private var paths: [DoodlePath] = []
    @State private var current: DoodlePath?
    @State private var selectedColor: Color = Color(red: 0.95, green: 0.33, blue: 0.32)

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)

                Canvas { ctx, _ in
                    for path in paths + (current.map { [$0] } ?? []) {
                        var p = Path()
                        guard let first = path.points.first else { continue }
                        p.move(to: first)
                        for pt in path.points.dropFirst() {
                            p.addLine(to: pt)
                        }
                        ctx.stroke(p, with: .color(path.color),
                                   style: StrokeStyle(lineWidth: path.width,
                                                      lineCap: .round, lineJoin: .round))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if current == nil {
                            current = DoodlePath(color: selectedColor, width: 12, points: [value.location])
                        } else {
                            current?.points.append(value.location)
                        }
                    }
                    .onEnded { _ in
                        if let done = current {
                            paths.append(done)
                        }
                        current = nil
                    }
            )
            .padding(.horizontal, 16)

            HStack(spacing: 10) {
                ForEach(Array(palette.enumerated()), id: \.offset) { _, color in
                    Button {
                        selectedColor = color
                        Haptics.tick()
                    } label: {
                        Circle()
                            .fill(color)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .strokeBorder(.white, lineWidth: selectedColor == color ? 3 : 0)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                            .scaleEffect(selectedColor == color ? 1.2 : 1.0)
                    }
                    .animation(.spring(response: 0.25, dampingFraction: 0.7), value: selectedColor == color)
                }
            }

            HStack(spacing: 16) {
                Button {
                    if !paths.isEmpty { paths.removeLast() }
                } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Color(red: 0.25, green: 0.4, blue: 0.55))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.white, in: Capsule())
                }

                Button {
                    paths.removeAll()
                    Haptics.strokeDone()
                } label: {
                    Label("Clear", systemImage: "trash")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.95, green: 0.33, blue: 0.32), in: Capsule())
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
        .background(
            LinearGradient(colors: [Color(red: 0.98, green: 0.66, blue: 0.37).opacity(0.25),
                                    Color(red: 0.96, green: 0.47, blue: 0.62).opacity(0.25)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle("Doodle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DoodleView()
    }
}
