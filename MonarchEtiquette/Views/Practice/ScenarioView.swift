import SwiftUI

struct ScenarioView: View {
    let scenarios: [Scenario]
    let categoryId: String
    let onComplete: (Double) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showingExplanation = false
    @State private var showingResult = false
    @State private var correctAnswers = 0

    private var currentScenario: Scenario? {
        guard currentIndex < scenarios.count else { return nil }
        return scenarios[currentIndex]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                RoyalBackground()

                if scenarios.isEmpty {
                    emptyState
                } else if showingResult {
                    QuizResultView(
                        correct: correctAnswers,
                        total: scenarios.count,
                        mode: .scenarioMode,
                        onDismiss: {
                            onComplete(Double(correctAnswers) / Double(max(scenarios.count, 1)))
                        }
                    )
                } else if let scenario = currentScenario {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            progressHeader
                                .padding(.horizontal, 24)
                                .padding(.top, 16)

                            situationCard(scenario: scenario)
                                .padding(.horizontal, 24)
                                .padding(.top, 32)

                            optionsSection(scenario: scenario)
                                .padding(.horizontal, 24)
                                .padding(.top, 24)

                            if showingExplanation {
                                explanationCard(scenario: scenario)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 20)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))

                                GoldButton(title: currentIndex + 1 < scenarios.count ? "Next Scenario" : "See Results") {
                                    advance()
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 24)
                                .transition(.opacity)
                            }

                            Spacer(minLength: 48)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showingExplanation)
                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingResult && !scenarios.isEmpty {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Back")
                                    .font(.inter(16))
                            }
                            .foregroundStyle(Color.mGold)
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var progressHeader: some View {
        HStack {
            Text("Scenario Mode")
                .font(.playfair(14))
                .tracking(1.4)
                .textCase(.uppercase)
                .foregroundStyle(Color.mGold)
            Spacer()
            Text("\(currentIndex + 1) / \(scenarios.count)")
                .font(.inter(14))
                .foregroundStyle(Color.mCream.opacity(0.7))
        }
    }

    private func situationCard(scenario: Scenario) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "text.bubble")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.mGold)
                Text("Situation")
                    .font(.playfair(13))
                    .tracking(1.3)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGold)
            }

            Text(scenario.situation)
                .font(.inter(16))
                .foregroundStyle(Color.mCream.opacity(0.9))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color.mGold.opacity(0.12), Color.mGoldLight.opacity(0.04)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.mGold.opacity(0.35), lineWidth: 0.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func optionsSection(scenario: Scenario) -> some View {
        VStack(spacing: 12) {
            ForEach(Array(scenario.options.enumerated()), id: \.offset) { index, option in
                scenarioOptionButton(option: option, index: index, scenario: scenario)
            }
        }
    }

    private func scenarioOptionButton(option: String, index: Int, scenario: Scenario) -> some View {
        let isSelected = selectedAnswer == index
        let isCorrect = index == scenario.correctIndex
        let showColors = showingExplanation

        var borderColor: Color {
            if showColors {
                return isCorrect ? Color.mGold : (isSelected ? Color.red.opacity(0.5) : Color.mGold.opacity(0.2))
            }
            return isSelected ? Color.mGold : Color.mGold.opacity(0.25)
        }

        return Button {
            guard !showingExplanation else { return }
            selectedAnswer = index
            withAnimation(.easeInOut(duration: 0.3).delay(0.15)) {
                showingExplanation = true
            }
            if index == scenario.correctIndex { correctAnswers += 1 }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(showColors && isCorrect ? Color.mGold : .clear)
                        .frame(width: 28, height: 28)
                    Circle()
                        .strokeBorder(borderColor, lineWidth: 0.8)
                        .frame(width: 28, height: 28)
                    if showColors && isCorrect {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color(red: 0.165, green: 0.039, blue: 0.063))
                    } else if showColors && isSelected && !isCorrect {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.red.opacity(0.8))
                    }
                }

                Text(option)
                    .font(.inter(15))
                    .foregroundStyle(Color.mCream.opacity(0.9))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(showColors && isCorrect ? Color.mGold.opacity(0.12) : Color.mCardBg)
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(borderColor, lineWidth: 0.6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .animation(.easeInOut(duration: 0.2), value: showingExplanation)
        }
        .buttonStyle(.plain)
        .disabled(showingExplanation)
    }

    private func explanationCard(scenario: Scenario) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.mGold)
                Text("Royal Guidance")
                    .font(.playfair(13))
                    .tracking(1.3)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGold)
            }
            Text(scenario.explanation)
                .font(.inter(14))
                .foregroundStyle(Color.mCream.opacity(0.85))
                .lineSpacing(4)
        }
        .padding(20)
        .royalCard(borderOpacity: 0.4)
    }

    private func advance() {
        if currentIndex + 1 < scenarios.count {
            currentIndex += 1
            selectedAnswer = nil
            showingExplanation = false
        } else {
            showingResult = true
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundStyle(Color.mGold.opacity(0.5))
            Text("No scenarios available for this topic yet.")
                .font(.inter(16))
                .foregroundStyle(Color.mCream.opacity(0.7))
                .multilineTextAlignment(.center)
            GoldButton(title: "Go Back") {
                onComplete(0)
            }
        }
        .padding(40)
    }
}
