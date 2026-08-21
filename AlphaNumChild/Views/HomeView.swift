import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    @AppStorage(SpeechCoach.soundKey) private var soundOn = true
    @State private var showResetDialog = false

    private let columns = [GridItem(.flexible(), spacing: 16),
                           GridItem(.flexible(), spacing: 16)]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 0.55, green: 0.83, blue: 1.0),
                                        Color(red: 0.8, green: 0.95, blue: 0.85)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        titleBlock
                            .padding(.top, 24)

                        if progress.totalStars > 0 {
                            starCounter
                        }

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(TraceCategory.allCases) { category in
                                NavigationLink {
                                    CharacterGridView(category: category)
                                } label: {
                                    HomeCard(emoji: cardEmoji(for: category),
                                             title: category.title,
                                             subtitle: category.badge,
                                             colors: category.gradient)
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        NavigationLink {
                            DoodleView()
                        } label: {
                            wideCard(emoji: "🖍️", title: "Doodle",
                                     subtitle: "Free drawing pad",
                                     colors: [Color(red: 0.98, green: 0.66, blue: 0.37),
                                              Color(red: 0.96, green: 0.47, blue: 0.62)])
                        }
                        .padding(.horizontal, 20)

                        NavigationLink {
                            StickerBookView()
                        } label: {
                            stickerBookCard
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 32)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showResetDialog = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        soundOn.toggle()
                        if !soundOn { SpeechCoach.shared.stop() }
                    } label: {
                        Image(systemName: soundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
            }
            .confirmationDialog("Grown-ups only",
                                isPresented: $showResetDialog,
                                titleVisibility: .visible) {
                Button("Reset all stars", role: .destructive) {
                    progress.resetAll()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Erase every earned star and start fresh?")
            }
        }
    }

    private var titleBlock: some View {
        VStack(spacing: 6) {
            HStack(spacing: 2) {
                ForEach(Array("ABC & 123".enumerated()), id: \.offset) { i, ch in
                    Text(String(ch))
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(rainbow[i % rainbow.count])
                }
            }
            .shadow(color: .white.opacity(0.7), radius: 2, y: 2)

            Text("Let's learn to write!")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(Color(red: 0.2, green: 0.35, blue: 0.5))
        }
    }

    private var starCounter: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            Text("\(progress.totalStars) stars earned")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color(red: 0.2, green: 0.35, blue: 0.5))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(.white.opacity(0.7), in: Capsule())
    }

    private var stickerBookCard: some View {
        let total = TraceCategory.allCases.reduce(0) { $0 + $1.characters.count }
        return wideCard(emoji: "🎁", title: "Sticker Book",
                        subtitle: "\(progress.totalStickers) of \(total) collected",
                        colors: [Color(red: 0.98, green: 0.75, blue: 0.25),
                                 Color(red: 0.95, green: 0.55, blue: 0.35)])
    }

    private func wideCard(emoji: String, title: String, subtitle: String,
                          colors: [Color]) -> some View {
        HStack(spacing: 14) {
            Text(emoji)
                .font(.system(size: 40))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            LinearGradient(colors: colors,
                           startPoint: .leading, endPoint: .trailing),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
    }

    private func cardEmoji(for category: TraceCategory) -> String {
        switch category {
        case .uppercase: return "🅰️"
        case .lowercase: return "✍️"
        case .numbers: return "🔢"
        case .words: return "📖"
        }
    }

    private let rainbow: [Color] = [.red, .orange, .green, .blue, .purple, .pink]
}

private struct HomeCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    let colors: [Color]

    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 52))
            Text(title)
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
    }
}

#Preview {
    HomeView()
        .environmentObject(ProgressStore())
}
