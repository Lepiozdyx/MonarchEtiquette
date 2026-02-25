import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        Group {
            switch selectedTab {
            case 0:
                HomeView(
                    onNavigateToPractice: { selectedTab = 2 },
                    onNavigateToLessons: { selectedTab = 1 }
                )
            case 1:
                LessonsView()
            case 2:
                PracticeView()
            case 3:
                AppProgressView()
            case 4:
                ProfileView()
            default:
                HomeView(
                    onNavigateToPractice: { selectedTab = 2 },
                    onNavigateToLessons: { selectedTab = 1 }
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

// MARK: - CustomTabBar

private struct TabMeta {
    let label: String
    let icon: String
}

private let tabItems: [TabMeta] = [
    TabMeta(label: "Home",     icon: "house"),
    TabMeta(label: "Lessons",  icon: "book"),
    TabMeta(label: "Practice", icon: "target"),
    TabMeta(label: "Progress", icon: "chart.line.uptrend.xyaxis"),
    TabMeta(label: "Profile",  icon: "person")
]

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 0) {
            LinearGradient.goldHorizontal
                .frame(height: 0.6)

            HStack(spacing: 0) {
                ForEach(Array(tabItems.enumerated()), id: \.offset) { index, item in
                    TabBarButton(
                        label: item.label,
                        icon: item.icon,
                        isSelected: selectedTab == index
                    ) {
                        selectedTab = index
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .background(LinearGradient.tabBarGradient)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: -4)
        }
    }
}

// MARK: - TabBarButton

private struct TabBarButton: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
            }
            .frame(maxWidth: .infinity)
            .frame(height: 49)
            .opacity(isSelected ? 1.0 : 0.6)
        }
        .buttonStyle(.plain)
        .animation(.default, value: isSelected)
    }
}

#Preview {
    MainTabView()
        .environment(DataManager())
        .environment(ProgressManager())
}
