import SwiftUI

struct GoldButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.playfair(18))
                    .tracking(1.8)
                    .textCase(.uppercase)
            }
            .foregroundStyle(Color(red: 0.165, green: 0.039, blue: 0.063))
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(LinearGradient.goldGradient)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.mGold, lineWidth: 0.6)
            )
            .shadow(color: Color.mGold.opacity(0.25), radius: 8, x: 0, y: 4)
        }
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.mGold)
                }
                Text(title)
                    .font(.playfair(16))
                    .tracking(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.mGold.opacity(0.5), lineWidth: 0.6)
            )
        }
    }
}

#Preview {
    ZStack {
        RoyalBackground()
        VStack(spacing: 16) {
            GoldButton(title: "Start Today's Practice") {}
            SecondaryButton(title: "View All Lessons", icon: "book") {}
        }
        .padding()
    }
}
