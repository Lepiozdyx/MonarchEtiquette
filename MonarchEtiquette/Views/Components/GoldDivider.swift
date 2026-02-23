import SwiftUI

struct GoldDivider: View {
    var body: some View {
        LinearGradient.goldHorizontal
            .frame(width: 128, height: 1)
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.playfair(20))
            .tracking(2)
            .textCase(.uppercase)
            .foregroundStyle(Color.mGoldLight)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
