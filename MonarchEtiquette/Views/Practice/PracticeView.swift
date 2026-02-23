import SwiftUI

struct PracticeView: View {
    @Environment(DataManager.self) private var dataManager
    @Environment(ProgressManager.self) private var progressManager
    @State private var viewModel: PracticeViewModel?
    @State private var showingQuiz = false
    @State private var showingScenario = false

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            RoyalBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    SectionHeader(title: "Select Topics")
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    topicsGrid
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    SectionHeader(title: "Practice Mode")
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    modeList
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    Text("Complete lessons to unlock more practice topics")
                        .font(.inter(13))
                        .italic()
                        .foregroundStyle(Color.mGold.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)

                    GoldDivider()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)

                    Spacer(minLength: 32)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = PracticeViewModel(dataManager: dataManager, progressManager: progressManager)
            }
        }
        .fullScreenCover(isPresented: $showingQuiz) {
            if let vm = viewModel {
                QuizView(
                    questions: vm.questionsForSession(),
                    categoryId: vm.selectedCategoryId,
                    mode: vm.selectedMode
                ) { score in
                    vm.recordResult(score: score)
                    showingQuiz = false
                }
            }
        }
        .fullScreenCover(isPresented: $showingScenario) {
            if let vm = viewModel {
                ScenarioView(
                    scenarios: vm.scenariosForSession(),
                    categoryId: vm.selectedCategoryId
                ) { score in
                    vm.recordResult(score: score)
                    showingScenario = false
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Practice")
                .font(.playfair(32))
                .tracking(3.84)
                .textCase(.uppercase)
                .foregroundStyle(Color.mGoldLight)

            Text("Select a topic and practice mode to begin")
                .font(.inter(15))
                .foregroundStyle(Color.mCream.opacity(0.75))
        }
    }

    private var topicsGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel?.categories ?? []) { category in
                topicCell(category: category)
            }
            mixedReviewCell
        }
    }

    private func topicCell(category: LessonCategory) -> some View {
        let isSelected = viewModel?.selectedCategoryId == category.id
        let isUnlocked = viewModel?.isCategoryUnlocked(category.id) ?? false

        return Button {
            if isUnlocked {
                viewModel?.selectedCategoryId = category.id
            }
        } label: {
            ZStack {
                VStack(spacing: 12) {
                    Image(systemName: category.sfSymbol)
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(isUnlocked ? Color.mGold : Color.mGold.opacity(0.4))

                    Text(category.title.components(separatedBy: " ").first ?? category.title)
                        .font(.inter(14, weight: .medium))
                        .foregroundStyle(isUnlocked ? Color.mCream : Color.mCream.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background(isSelected ? Color.mGold.opacity(0.15) : Color.mCardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            isSelected ? Color.mGold : Color.mGold.opacity(0.3),
                            lineWidth: isSelected ? 1 : 0.6
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))

                if !isUnlocked {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Locked")
                                .font(.inter(10, weight: .medium))
                                .foregroundStyle(Color.mCream.opacity(0.7))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.mCardBg)
                                .clipShape(Capsule())
                                .overlay(Capsule().strokeBorder(Color.mGold.opacity(0.3), lineWidth: 0.6))
                                .padding(8)
                        }
                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
    }

    private var mixedReviewCell: some View {
        let isSelected = viewModel?.selectedCategoryId == "mixed"
        return Button {
            viewModel?.selectedCategoryId = "mixed"
        } label: {
            VStack(spacing: 12) {
                Image(systemName: "shuffle")
                    .font(.system(size: 28, weight: .light))
                    .foregroundStyle(Color.mGold)

                Text("Mixed Review")
                    .font(.inter(14, weight: .medium))
                    .foregroundStyle(Color.mCream)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .background(isSelected ? Color.mGold.opacity(0.15) : Color.mCardBg)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        isSelected ? Color.mGold : Color.mGold.opacity(0.3),
                        lineWidth: isSelected ? 1 : 0.6
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var modeList: some View {
        VStack(spacing: 12) {
            ForEach(PracticeMode.allCases) { mode in
                Button {
                    viewModel?.selectedMode = mode
                    if mode == .scenarioMode {
                        showingScenario = true
                    } else {
                        showingQuiz = true
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(mode.rawValue)
                                .font(.playfair(18))
                                .foregroundStyle(Color.mGold)
                            HStack(spacing: 8) {
                                Text(mode.subtitle)
                                    .font(.inter(13))
                                    .foregroundStyle(Color.mCream.opacity(0.7))
                                Circle()
                                    .fill(Color.mGold.opacity(0.5))
                                    .frame(width: 3, height: 3)
                                Text(mode.duration)
                                    .font(.inter(13))
                                    .foregroundStyle(Color.mCream.opacity(0.7))
                            }
                        }
                        Spacer()
                        Text("→")
                            .font(.inter(16, weight: .medium))
                            .foregroundStyle(Color.mGold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .royalCard(borderOpacity: 0.3)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    PracticeView()
        .environment(DataManager())
        .environment(ProgressManager())
}
