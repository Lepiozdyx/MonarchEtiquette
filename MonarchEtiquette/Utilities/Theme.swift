import SwiftUI

// MARK: - Colors
extension Color {
    static let mBackground = Color(red: 0.294, green: 0.059, blue: 0.098)
    static let mBackgroundDeep = Color(red: 0.165, green: 0.039, blue: 0.063)
    static let mGold = Color(red: 0.776, green: 0.655, blue: 0.369)
    static let mGoldLight = Color(red: 0.902, green: 0.827, blue: 0.639)
    static let mCream = Color(red: 0.961, green: 0.945, blue: 0.910)
    static let mCardBg = Color(red: 0.165, green: 0.039, blue: 0.063).opacity(0.5)
    static let mCardBorder = Color(red: 0.776, green: 0.655, blue: 0.369).opacity(0.3)

    static let backgroundGradientTop = Color(red: 0.294, green: 0.059, blue: 0.098)
    static let backgroundGradientBottom = Color(red: 0.165, green: 0.039, blue: 0.063)
}

// MARK: - Gradients
extension LinearGradient {
    static let backgroundGradient = LinearGradient(
        colors: [.backgroundGradientTop, .backgroundGradientBottom],
        startPoint: .top, endPoint: .bottom
    )
    static let goldGradient = LinearGradient(
        colors: [.mGold, .mGoldLight],
        startPoint: UnitPoint(x: 0.1, y: 0.9),
        endPoint: UnitPoint(x: 0.9, y: 0.1)
    )
    static let goldHorizontal = LinearGradient(
        colors: [.clear, .mGold, .clear],
        startPoint: .leading, endPoint: .trailing
    )
    static let goldBarGradient = LinearGradient(
        colors: [.mGold, .mGoldLight],
        startPoint: .leading, endPoint: .trailing
    )
    static let tabBarGradient = LinearGradient(
        colors: [Color(red: 0.165, green: 0.039, blue: 0.063), Color(red: 0.102, green: 0.024, blue: 0.031)],
        startPoint: .top, endPoint: .bottom
    )
    static let cardImageGradient = LinearGradient(
        colors: [.clear, Color(red: 0.165, green: 0.039, blue: 0.063).opacity(0.9)],
        startPoint: .top, endPoint: .bottom
    )
}

// MARK: - Fonts
extension Font {
    static func playfair(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .custom("PlayfairDisplay-Medium", size: size)
    }
    
    static func playfairRegular(_ size: CGFloat) -> Font {
        .custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func inter(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .medium: return .custom("Inter-Medium", size: size)
        default: return .custom("Inter-Regular", size: size)
        }
    }
}

// MARK: - View Modifiers
struct RoyalCardModifier: ViewModifier {
    var borderOpacity: Double = 0.3

    func body(content: Content) -> some View {
        content
            .background(Color.mCardBg)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.mGold.opacity(borderOpacity), lineWidth: 0.6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func royalCard(borderOpacity: Double = 0.3) -> some View {
        modifier(RoyalCardModifier(borderOpacity: borderOpacity))
    }
}

// MARK: - Background
struct RoyalBackground: View {
    var body: some View {
        LinearGradient.backgroundGradient
            .ignoresSafeArea()
    }
}
