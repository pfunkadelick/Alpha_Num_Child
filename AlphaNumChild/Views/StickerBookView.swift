import SwiftUI

/// The collection of phonics stickers earned by finishing characters.
struct StickerBookView: View {
    @EnvironmentObject private var progress: ProgressStore

    private let columns = [GridItem(.adaptive(minimum: 76), spacing: 12)]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 1.0, green: 0.87, blue: 0.6).opacity(0.5),
                                    Color(red: 0.72, green: 0.9, blue: 0.8).opacity(0.5)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("\(progress.totalStickers) of \(totalCount) collected")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Color(red: 0.45, green: 0.35, blue: 0.2))
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    ForEach(TraceCategory.allCases) { category in
                        section(for: category)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Sticker Book")
        .navigationBarTitleDisplayMode(.large)
    }

    private var totalCount: Int {
        TraceCategory.allCases.reduce(0) { $0 + $1.characters.count }
    }

    private func section(for category: TraceCategory) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category.title)
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(category.gradient[0])
                .padding(.horizontal, 20)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(category.characters) { character in
                    StickerSlot(character: character,
                                collected: progress.hasSticker(for: character.id))
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct StickerSlot: View {
    let character: TraceCharacter
    let collected: Bool

    var body: some View {
        VStack(spacing: 4) {
            if collected {
                Text(Rewards.reward(for: character).sticker)
                    .font(.system(size: 38))
            } else {
                Text("?")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(.systemGray4))
            }
            Text(character.glyph)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(collected ? Color(red: 0.35, green: 0.45, blue: 0.55)
                                           : Color(.systemGray3))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(collected ? AnyShapeStyle(.white)
                              : AnyShapeStyle(.white.opacity(0.45)),
                    in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(collected ? 0.08 : 0.03), radius: 4, y: 2)
    }
}

#Preview {
    NavigationStack {
        StickerBookView()
            .environmentObject(ProgressStore())
    }
}
