import SwiftUI

struct CharacterGridView: View {
    let category: TraceCategory
    @EnvironmentObject private var progress: ProgressStore

    private let columns = [GridItem(.adaptive(minimum: 84), spacing: 14)]

    var body: some View {
        ZStack {
            LinearGradient(colors: category.gradient.map { $0.opacity(0.25) },
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(Array(category.characters.enumerated()), id: \.element.id) { index, character in
                        NavigationLink {
                            TracingView(category: category, startIndex: index)
                        } label: {
                            CharacterTile(character: character,
                                          colors: category.gradient,
                                          stars: progress.stars(for: character.id),
                                          sticker: progress.hasSticker(for: character.id)
                                              ? Rewards.reward(for: character).sticker : nil)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct CharacterTile: View {
    let character: TraceCharacter
    let colors: [Color]
    let stars: Int
    let sticker: String?

    var body: some View {
        VStack(spacing: 6) {
            Text(character.glyph)
                .font(.system(size: character.glyph.count > 1 ? 24 : 46,
                              weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: colors,
                                   startPoint: .top, endPoint: .bottom)
                )

            HStack(spacing: 2) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < stars ? "star.fill" : "star")
                        .font(.system(size: 10))
                        .foregroundStyle(i < stars ? .yellow : Color(.systemGray4))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 96)
        .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(alignment: .topTrailing) {
            if let sticker {
                Text(sticker)
                    .font(.system(size: 16))
                    .padding(6)
            }
        }
        .shadow(color: .black.opacity(0.08), radius: 5, y: 3)
    }
}

#Preview {
    NavigationStack {
        CharacterGridView(category: .uppercase)
            .environmentObject(ProgressStore())
    }
}
