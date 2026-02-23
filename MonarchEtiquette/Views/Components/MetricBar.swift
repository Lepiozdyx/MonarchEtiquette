import SwiftUI

struct MetricBar: View {
    let title: String
    let value: Double
    var animated: Bool = true

    @State private var animatedValue: Double = 0

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.playfair(18))
                    .foregroundStyle(Color.mGoldLight)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.inter(20))
                    .foregroundStyle(Color.mGold)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.mGold.opacity(0.15))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 100)
                        .fill(LinearGradient.goldBarGradient)
                        .frame(width: geo.size.width * (animated ? animatedValue : value), height: 8)
                        .shadow(color: Color.mGold.opacity(0.25), radius: 5)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .royalCard(borderOpacity: 0.25)
        .onAppear {
            if animated {
                withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                    animatedValue = value
                }
            }
        }
        .onChange(of: value) { _, newValue in
            withAnimation(.easeOut(duration: 0.6)) {
                animatedValue = newValue
            }
        }
    }
}

#Preview {
    ZStack {
        RoyalBackground()
        VStack(spacing: 12) {
            MetricBar(title: "Poise", value: 0.78)
            MetricBar(title: "Composure", value: 0.65)
            MetricBar(title: "Elegance", value: 0.82)
            MetricBar(title: "Consistency", value: 0.70)
        }
        .padding()
    }
}
