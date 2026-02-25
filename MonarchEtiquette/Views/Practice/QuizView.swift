import SwiftUI

struct QuizView: View {
    let questions: [QuizQuestion]
    let categoryId: String
    let mode: PracticeMode
    let onComplete: (Double) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showingResult = false
    @State private var correctAnswers = 0
    @State private var showingFeedback = false

    private var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                RoyalBackground()

                if showingResult {
                    QuizResultView(
                        correct: correctAnswers,
                        total: questions.count,
                        mode: mode,
                        onDismiss: {
                            onComplete(Double(correctAnswers) / Double(max(questions.count, 1)))
                        }
                    )
                } else if let question = currentQuestion {
                    VStack(spacing: 0) {
                        progressHeader
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                        questionCard(question: question)
                            .padding(.horizontal, 24)
                            .padding(.top, 32)

                        answersSection(question: question)
                            .padding(.horizontal, 24)
                            .padding(.top, 24)

                        Spacer()

                        if showingFeedback {
                            nextButton
                                .padding(.horizontal, 24)
                                .padding(.bottom, 40)
                        }
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentIndex)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingResult {
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
        VStack(spacing: 12) {
            HStack {
                Text(mode.rawValue)
                    .font(.playfair(14))
                    .tracking(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGold)
                Spacer()
                Text("\(currentIndex + 1) / \(questions.count)")
                    .font(.inter(14))
                    .foregroundStyle(Color.mCream.opacity(0.7))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.mGold.opacity(0.15))
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 100)
                        .fill(LinearGradient.goldBarGradient)
                        .frame(
                            width: geo.size.width * CGFloat(currentIndex + 1) / CGFloat(max(questions.count, 1)),
                            height: 4
                        )
                        .animation(.easeInOut, value: currentIndex)
                }
            }
            .frame(height: 4)
        }
    }

    private func questionCard(question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(question.question)
                .font(.playfair(20))
                .foregroundStyle(Color.mGoldLight)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .royalCard(borderOpacity: 0.35)
    }

    private func answersSection(question: QuizQuestion) -> some View {
        VStack(spacing: 12) {
            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                answerButton(option: option, index: index, question: question)
            }
        }
    }

    private func answerButton(option: String, index: Int, question: QuizQuestion) -> some View {
        let isSelected = selectedAnswer == index
        let isCorrect = index == question.correctIndex
        let showColors = showingFeedback

        var borderColor: Color {
            if showColors {
                return isCorrect ? Color.mGold : (isSelected ? Color(red: 0.8, green: 0.2, blue: 0.2) : Color.mGold.opacity(0.2))
            }
            return isSelected ? Color.mGold : Color.mGold.opacity(0.25)
        }

        var bgColor: Color {
            if showColors {
                return isCorrect ? Color.mGold.opacity(0.15) : (isSelected ? Color.red.opacity(0.1) : Color.mCardBg)
            }
            return isSelected ? Color.mGold.opacity(0.15) : Color.mCardBg
        }

        return Button {
            guard !showingFeedback else { return }
            selectedAnswer = index
            withAnimation(.easeInOut(duration: 0.2).delay(0.1)) {
                showingFeedback = true
            }
            if index == question.correctIndex {
                correctAnswers += 1
            }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(showColors && isCorrect ? Color.mGold : (isSelected ? Color.mGold.opacity(0.2) : Color.clear))
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
                    .foregroundStyle(Color.mCream.opacity(showColors && !isCorrect && !isSelected ? 0.5 : 0.9))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(bgColor)
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(borderColor, lineWidth: 0.6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .animation(.easeInOut(duration: 0.2), value: showingFeedback)
        }
        .buttonStyle(.plain)
        .disabled(showingFeedback)
    }

    private var nextButton: some View {
        Button {
            if currentIndex + 1 < questions.count {
                currentIndex += 1
                selectedAnswer = nil
                showingFeedback = false
            } else {
                showingResult = true
            }
        } label: {
            Text(currentIndex + 1 < questions.count ? "Next Question" : "See Results")
                .font(.playfair(18))
                .tracking(1.8)
                .textCase(.uppercase)
                .foregroundStyle(Color(red: 0.165, green: 0.039, blue: 0.063))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(LinearGradient.goldGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct QuizResultView: View {
    let correct: Int
    let total: Int
    let mode: PracticeMode
    let onDismiss: () -> Void

    private var percentage: Int { Int(Double(correct) / Double(max(total, 1)) * 100) }

    private var grade: String {
        switch percentage {
        case 90...100: return "Flawless"
        case 75..<90: return "Excellent"
        case 60..<75: return "Refined"
        case 40..<60: return "Developing"
        default: return "Needs Practice"
        }
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: percentage >= 75 ? "crown.fill" : "book.fill")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(Color.mGold)

            VStack(spacing: 12) {
                Text(grade)
                    .font(.playfair(36))
                    .tracking(3)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.mGoldLight)

                Text("\(correct) of \(total) correct")
                    .font(.inter(16))
                    .foregroundStyle(Color.mCream.opacity(0.7))
            }

            ZStack {
                Circle()
                    .stroke(Color.mGold.opacity(0.15), lineWidth: 12)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: CGFloat(percentage) / 100)
                    .stroke(LinearGradient.goldGradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1.0), value: percentage)

                Text("\(percentage)%")
                    .font(.playfairRegular(32))
                    .foregroundStyle(Color.mGold)
            }

            Text("Your Grace Score has been updated")
                .font(.inter(14))
                .italic()
                .foregroundStyle(Color.mCream.opacity(0.6))

            Spacer()

            GoldButton(title: "Continue") { onDismiss() }
                .padding(.horizontal, 24)

            Spacer(minLength: 40)
        }
    }
}

#Preview {
    let sampleQuestions = [
        QuizQuestion(id: "1", question: "Which fork is used first at a formally set table?", options: ["The fork closest to the plate", "The fork furthest from the plate", "The dessert fork", "It does not matter"], correctIndex: 1)
    ]
    return ZStack {
        RoyalBackground()
        QuizView(questions: sampleQuestions, categoryId: "dining", mode: .quickTest) { _ in }
    }
}
