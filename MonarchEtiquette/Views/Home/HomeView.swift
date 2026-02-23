import SwiftUI

struct HomeView: View {
    @Environment(DataManager.self) private var dataManager
    @Environment(ProgressManager.self) private var progressManager
    @State private var viewModel: HomeViewModel?
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            RoyalBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    logoSection
                        .padding(.top, 32)

                    if let advice = viewModel?.todayAdvice {
                        adviceCard(advice: advice)
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                    }

                    GoldButton(title: "Start Today's Practice") {
                        selectedTab = 2
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                    continueLearningSectionTitle
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    if let category = viewModel?.featuredCategory {
                        Button {
                            selectedTab = 1
                        } label: {
                            LessonCard(category: category, isCompact: true)
                                .padding(.horizontal, 24)
                        }
                        .buttonStyle(.plain)
                    }

                    progressSectionTitle
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    HStack(spacing: 16) {
                        StatCard(
                            value: "\(progressManager.completedLessonsCount)",
                            label: "Lessons Completed",
                            sfSymbol: "checkmark.circle"
                        )
                        StatCard(
                            value: "\(progressManager.currentStreak)",
                            label: "Day Streak",
                            sfSymbol: "flame"
                        )
                    }
                    .padding(.horizontal, 24)

                    GoldDivider()
                        .padding(.top, 32)

                    Spacer(minLength: 32)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = HomeViewModel(dataManager: dataManager, progressManager: progressManager)
            }
        }
    }

    private var logoSection: some View {
        VStack(spacing: 0) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 189, height: 130)
        }
    }

    private func adviceCard(advice: DailyAdvice) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: advice.sfSymbol)
                .font(.system(size: 22, weight: .light))
                .foregroundStyle(Color.mGold)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Royal Advice")
                    .font(.playfair(17))
                    .tracking(1.7)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGoldLight)

                Text(advice.tip)
                    .font(.inter(15))
                    .foregroundStyle(Color.mCream.opacity(0.9))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(
            LinearGradient(
                colors: [Color.mGold.opacity(0.18), Color.mGoldLight.opacity(0.06)],
                startPoint: UnitPoint(x: 0.15, y: 0.15),
                endPoint: UnitPoint(x: 0.85, y: 0.85)
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.mGold.opacity(0.35), lineWidth: 0.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var continueLearningSectionTitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Continue Learning")
        }
    }

    private var progressSectionTitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Your Progress")
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environment(DataManager())
        .environment(ProgressManager())
}
