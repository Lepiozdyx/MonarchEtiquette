import SwiftUI

struct StatCard: View {
    let value: String
    let label: String
    let sfSymbol: String

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: sfSymbol)
                .font(.system(size: 22, weight: .light))
                .foregroundStyle(Color.mGold)
                .frame(height: 28)

            Text(value)
                .font(.playfairRegular(28))
                .foregroundStyle(Color.mGold)
                .padding(.top, 8)

            Text(label)
                .font(.inter(13))
                .foregroundStyle(Color.mCream.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .royalCard(borderOpacity: 0.25)
    }
}

struct GraceScoreCard: View {
    let score: Int
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "crown")
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(Color.mGold)
                Text("Grace Score")
                    .font(.playfairRegular(16))
                    .tracking(1.6)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGoldLight)
            }

            Text("\(score)")
                .font(.playfairRegular(56))
                .foregroundStyle(Color.mGold)

            Text(subtitle)
                .font(.inter(14))
                .italic()
                .foregroundStyle(Color.mCream.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
        .background(
            LinearGradient(
                colors: [Color.mGold.opacity(0.25), Color.mGoldLight.opacity(0.08)],
                startPoint: UnitPoint(x: 0.2, y: 0.15),
                endPoint: UnitPoint(x: 0.8, y: 0.85)
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.mGold.opacity(0.5), lineWidth: 0.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ZStack {
        RoyalBackground()
        VStack(spacing: 16) {
            GraceScoreCard(score: 74, subtitle: "You're on the path to flawless elegance")
            HStack(spacing: 16) {
                StatCard(value: "12", label: "Lessons Completed", sfSymbol: "checkmark.circle")
                StatCard(value: "7", label: "Day Streak", sfSymbol: "flame")
            }
        }
        .padding()
    }
}
