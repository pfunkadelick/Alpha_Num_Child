import SwiftUI

/// Hosts the tracing session for a category, with previous/next navigation.
struct TracingView: View {
    let category: TraceCategory
    @State private var index: Int

    init(category: TraceCategory, startIndex: Int) {
        self.category = category
        _index = State(initialValue: startIndex)
    }

    var body: some View {
        TracingSession(
            category: category,
            character: category.characters[index],
            hasPrevious: index > 0,
            hasNext: index < category.characters.count - 1,
            goPrevious: { if index > 0 { index -= 1 } },
            goNext: { if index < category.characters.count - 1 { index += 1 } }
        )
        // A new id tears down and rebuilds the session (and its engine)
        // whenever the character changes.
        .id(category.characters[index].id)
    }
}

/// One character's tracing exercise.
private struct TracingSession: View {
    let category: TraceCategory
    let character: TraceCharacter
    let hasPrevious: Bool
    let hasNext: Bool
    let goPrevious: () -> Void
    let goNext: () -> Void

    @EnvironmentObject private var progress: ProgressStore
    @StateObject private var engine: TraceEngine
    @State private var celebrating = false
    @State private var newSticker = false

    init(category: TraceCategory, character: TraceCharacter,
         hasPrevious: Bool, hasNext: Bool,
         goPrevious: @escaping () -> Void, goNext: @escaping () -> Void) {
        self.category = category
        self.character = character
        self.hasPrevious = hasPrevious
        self.hasNext = hasNext
        self.goPrevious = goPrevious
        self.goNext = goNext
        _engine = StateObject(wrappedValue: TraceEngine(character: character))
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: category.gradient.map { $0.opacity(0.25) },
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                header

                TracingCanvasView(engine: engine, category: category)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 16)

                controls
                    .padding(.bottom, 8)
            }

            if celebrating {
                CelebrationOverlay(
                    reward: Rewards.reward(for: character),
                    isNewSticker: newSticker,
                    hasNext: hasNext,
                    onAgain: {
                        celebrating = false
                        engine.reset()
                        engine.startDemo()
                    },
                    onNext: goNext
                )
                .transition(.opacity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(character.glyph)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(category.gradient[0])
            }
        }
        .onAppear {
            engine.onStrokeCompleted = { Haptics.strokeDone() }
            engine.onCompleted = {
                Haptics.success()
                SpeechCoach.shared.praise(character)
                newSticker = !progress.hasSticker(for: character.id)
                progress.award(character.id)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    celebrating = true
                }
            }
            SpeechCoach.shared.announce(character)
            engine.startDemo()
        }
        .onDisappear {
            engine.stopDemo()
        }
    }

    private var header: some View {
        HStack(spacing: 6) {
            ForEach(0..<engine.strokes.count, id: \.self) { i in
                Capsule()
                    .fill(i < engine.strokeIndex || engine.completed
                          ? category.gradient[0]
                          : Color(.systemGray4))
                    .frame(width: 30, height: 8)
            }
        }
        .padding(.top, 4)
    }

    private var controls: some View {
        HStack(spacing: 18) {
            RoundControl(symbol: "chevron.left", enabled: hasPrevious, action: goPrevious)

            RoundControl(symbol: "arrow.counterclockwise", enabled: true) {
                engine.reset()
                engine.startDemo()
            }

            Button {
                engine.startDemo()
            } label: {
                Label("Show me", systemImage: "wand.and.stars")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(colors: category.gradient,
                                       startPoint: .leading, endPoint: .trailing),
                        in: Capsule()
                    )
            }

            RoundControl(symbol: "chevron.right", enabled: hasNext, action: goNext)
        }
    }
}

private struct RoundControl: View {
    let symbol: String
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(enabled ? Color(red: 0.25, green: 0.4, blue: 0.55) : Color(.systemGray4))
                .frame(width: 52, height: 52)
                .background(.white, in: Circle())
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        }
        .disabled(!enabled)
    }
}

/// Confetti, the phonics sticker reward, and Again/Next buttons.
private struct CelebrationOverlay: View {
    let reward: Rewards.Reward
    let isNewSticker: Bool
    let hasNext: Bool
    let onAgain: () -> Void
    let onNext: () -> Void

    @State private var rewardScale: CGFloat = 0.2

    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            ConfettiView()
                .allowsHitTesting(false)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text(reward.display)
                    .font(.system(size: reward.display.count > 4 ? 44 : 96))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .scaleEffect(rewardScale)
                    .shadow(color: .yellow.opacity(0.5), radius: 14)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                            rewardScale = 1.0
                        }
                    }

                Text(reward.phrase)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .shadow(radius: 4)
                    .padding(.horizontal, 20)

                if isNewSticker {
                    Label("New sticker collected!", systemImage: "sparkles")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.yellow)
                        .shadow(radius: 3)
                }

                HStack(spacing: 16) {
                    Button(action: onAgain) {
                        Label("Again", systemImage: "arrow.counterclockwise")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(Color(red: 0.25, green: 0.4, blue: 0.55))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(.white, in: Capsule())
                    }

                    if hasNext {
                        Button(action: onNext) {
                            Label("Next", systemImage: "arrow.right")
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 14)
                                .background(Color(red: 0.29, green: 0.72, blue: 0.47), in: Capsule())
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TracingView(category: .uppercase, startIndex: 0)
            .environmentObject(ProgressStore())
    }
}
