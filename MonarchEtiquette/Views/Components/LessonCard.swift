import SwiftUI

struct LessonCard: View {
    let category: LessonCategory
    var isCompact: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            coverImage

            infoRow
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0.165, green: 0.039, blue: 0.063).opacity(0.8),
                         Color(red: 0.165, green: 0.039, blue: 0.063).opacity(0.5)],
                startPoint: UnitPoint(x: 0.2, y: 0.15),
                endPoint: UnitPoint(x: 0.8, y: 0.85)
            )
        )
        .overlay(
            VStack(spacing: 0) {
                Rectangle()
                    .fill(LinearGradient.goldHorizontal)
                    .frame(height: 1)
                Spacer()
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.mGold.opacity(0.4), lineWidth: 0.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    @ViewBuilder
    private var coverImage: some View {
        if !isCompact {
            ZStack {
                Image(category.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 128)
                    .clipped()

                LinearGradient.cardImageGradient
            }
            .frame(height: 128)
            .clipped()
        }
    }

    private var infoRow: some View {
        HStack(spacing: 16) {
            categoryIcon

            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.playfair(18))
                    .tracking(1.44)
                    .foregroundStyle(Color.mGoldLight)
                    .lineLimit(1)

                Text(category.subtitle)
                    .font(.inter(14, weight: .medium))
                    .foregroundStyle(Color.mCream.opacity(0.8))
                    .lineLimit(2)
            }

            Spacer()

            Text("→")
                .font(.inter(16, weight: .medium))
                .foregroundStyle(Color.mGold)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, isCompact ? 16 : 20)
    }

    private var categoryIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.mGold.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.mGold.opacity(0.3), lineWidth: 0.6)
                )
            Image(systemName: category.sfSymbol)
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(Color.mGold)
        }
        .frame(width: 48, height: 48)
    }
}

#Preview {
    let sampleCategory = LessonCategory(
        id: "dining",
        title: "Dining Etiquette",
        subtitle: "Proper table manners and silverware handling",
        imageName: "diningElegance",
        sfSymbol: "fork.knife",
        lessons: [],
        quizzes: [],
        scenarios: []
    )
    return ZStack {
        RoyalBackground()
        VStack(spacing: 16) {
            LessonCard(category: sampleCategory)
            LessonCard(category: sampleCategory, isCompact: true)
        }
        .padding()
    }
}
