import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Skip") {
                    hasCompletedOnboarding = true
                }
                .font(.inter(16))
                .foregroundStyle(.accent)
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    PageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .ignoresSafeArea(edges: .top)
            
            GoldButton(title: currentPage < pages.count - 1
                       ? "Next"
                       : "Get Started") {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    hasCompletedOnboarding = true
                }
            }
            .padding([.bottom, .horizontal], 24)
        }
        .background(
            Image(.onbbg)
                .resizable()
                .ignoresSafeArea()
        )
    }
    
    private let pages: [Page] = [
        Page(
            icon: "logo",
            title: "Become the embodiment of elegance.",
            description: "Royal manners are not status. They are skill."
        ),
        Page(
            icon: "butterfly",
            title: "Manners shape first impressions.",
            description: "Composure is power. Refinement is advantage."
        )
    ]
}

struct Page {
    let icon: String
    let title: String
    let description: String
}

struct PageView: View {
    let page: Page
    
    var body: some View {
        VStack(spacing: 40) {
            Image(page.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .padding(.horizontal)

            VStack(spacing: 10) {
                Text(page.title)
                    .font(.playfair(24))
                    .tracking(2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGoldLight)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.inter(18))
                    .foregroundStyle(Color.mCream.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}


#Preview {
    OnboardingView()
}

