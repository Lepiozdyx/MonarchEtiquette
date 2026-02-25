import SwiftUI

struct AppProgressView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var viewModel: ProgressViewModel?

    var body: some View {
        ZStack {
            RoyalBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    if let vm = viewModel {
                        GraceScoreCard(
                            score: vm.graceScore,
                            subtitle: vm.graceScoreSubtitle
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                        streakCard(streak: vm.currentStreak)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                        SectionHeader(title: "Weekly Practice")
                            .padding(.horizontal, 24)
                            .padding(.top, 32)

                        weeklyChart(activity: vm.weeklyActivity())
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                        SectionHeader(title: "Refinement Metrics")
                            .padding(.horizontal, 24)
                            .padding(.top, 32)

                        VStack(spacing: 12) {
                            ForEach(vm.orderedMetrics, id: \.0) { title, value in
                                MetricBar(title: title, value: value)
                            }
                        }
                        .padding(.horizontal, 24)

                        GoldDivider()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 32)
                    }

                    Spacer(minLength: 32)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ProgressViewModel(progressManager: progressManager)
            }
        }
    }

    private var headerSection: some View {
        Text("Progress")
            .font(.playfair(32))
            .tracking(3.84)
            .textCase(.uppercase)
            .foregroundStyle(Color.mGoldLight)
    }

    private func streakCard(streak: Int) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.mGold.opacity(0.2))
                    .overlay(Circle().strokeBorder(Color.mGold.opacity(0.4), lineWidth: 0.6))
                Image(systemName: "calendar")
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(Color.mGold)
            }
            .frame(width: 49, height: 49)

            VStack(alignment: .leading, spacing: 2) {
                Text("Current Streak")
                    .font(.playfair(14))
                    .tracking(1.12)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGoldLight.opacity(0.9))

                Text("Keep practicing daily")
                    .font(.inter(13))
                    .foregroundStyle(Color.mCream.opacity(0.7))
            }

            Spacer()

            HStack(alignment: .bottom, spacing: 4) {
                Text("\(streak)")
                    .font(.playfairRegular(36))
                    .foregroundStyle(Color.mGold)
                Text("days")
                    .font(.inter(16))
                    .foregroundStyle(Color.mCream.opacity(0.7))
                    .padding(.bottom, 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .royalCard(borderOpacity: 0.3)
    }

    private func weeklyChart(activity: [(day: String, hasActivity: Bool)]) -> some View {
        VStack(spacing: 16) {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(activity, id: \.day) { item in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                item.hasActivity
                                    ? LinearGradient.goldBarGradient
                                    : LinearGradient(colors: [Color.mGold.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(height: item.hasActivity ? 80 : 8)
                            .animation(.spring(duration: 0.5), value: item.hasActivity)

                        Text(item.day)
                            .font(.inter(12))
                            .foregroundStyle(Color.mCream.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 100, alignment: .bottom)

            Text("Sessions completed this week")
                .font(.inter(13))
                .foregroundStyle(Color.mCream.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .royalCard(borderOpacity: 0.25)
    }
}

#Preview {
    AppProgressView()
        .environment(ProgressManager())
}
