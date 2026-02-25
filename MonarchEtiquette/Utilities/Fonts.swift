import SwiftUI

enum Fonts: String {
    case medium = "PlayfairDisplay-Medium"
    case regular = "PlayfairDisplay-Regular"
}

extension Text {
    func pdFont(
        _ size: CGFloat,
        color: Color = .accent,
        textAlignment: TextAlignment = .center,
        font: Fonts = .regular
    ) -> some View {
        let baseFont = UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        
        let scaledFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: baseFont)

        return self
            .font(Font(scaledFont))
            .foregroundStyle(color)
            .multilineTextAlignment(textAlignment)
    }
}

struct Extensions: View {
    var body: some View {
        Text("Hello, World!")
            .pdFont(40, font: .medium)
    }
}

#Preview {
    Extensions()
        .padding()
        .background(.black)
}
