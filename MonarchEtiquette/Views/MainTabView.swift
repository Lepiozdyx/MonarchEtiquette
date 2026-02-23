import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    private let tabs: [(label: String, icon: String)] = [
        ("Home", "house"),
        ("Lessons", "book"),
        ("Practice", "target"),
        ("Progress", "chart.line.uptrend.xyaxis"),
        ("Profile", "person")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView(selectedTab: $selectedTab)
                }
                .tag(0)

                NavigationStack {
                    LessonsView()
                }
                .tag(1)

                NavigationStack {
                    PracticeView()
                }
                .tag(2)

                NavigationStack {
                    AppProgressView()
                }
                .tag(3)

                NavigationStack {
                    ProfileView()
                }
                .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            customTabBar
        }
        .ignoresSafeArea()
    }

    private var tabBarHeight: CGFloat {
        56 + 12 + max(safeAreaBottomInset, 8)
    }

    private var customTabBar: some View {
        VStack(spacing: 0) {
            LinearGradient.goldHorizontal
                .frame(height: 0.6)

            HStack(spacing: 0) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    tabItem(index: index, label: tab.label, icon: tab.icon)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, max(safeAreaBottomInset, 8))
            .background(LinearGradient.tabBarGradient)
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: -4)
        }
    }

    private func tabItem(index: Int, label: String, icon: String) -> some View {
        let isSelected = selectedTab == index

        return Button {
            selectedTab = index
        } label: {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.mGold.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.mGold.opacity(0.3), lineWidth: 0.6)
                        )
                }

                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(isSelected ? Color.mGold : Color.mCream)

                    Text(label)
                        .font(.inter(11, weight: .medium))
                        .tracking(0.22)
                        .foregroundStyle(isSelected ? Color.mGold : Color.mCream)
                }
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .opacity(isSelected ? 1.0 : 0.6)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    private var safeAreaBottomInset: CGFloat {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.safeAreaInsets.bottom ?? 0
    }
}

#Preview {
    MainTabView()
        .environment(DataManager())
        .environment(ProgressManager())
}
