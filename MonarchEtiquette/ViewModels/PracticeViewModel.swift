import Foundation
import Observation

@Observable
final class PracticeViewModel {
    private let dataManager: DataManager
    private let progressManager: ProgressManager

    var categories: [LessonCategory] = []
    var selectedCategoryId: String = "dining"
    var selectedMode: PracticeMode = .quickTest
    var showingQuiz = false
    var showingScenario = false

    init(dataManager: DataManager, progressManager: ProgressManager) {
        self.dataManager = dataManager
        self.progressManager = progressManager
        categories = dataManager.categories
    }

    func isCategoryUnlocked(_ id: String) -> Bool {
        progressManager.isCategoryUnlocked(id)
    }

    var selectedCategory: LessonCategory? {
        categories.first { $0.id == selectedCategoryId }
    }

    func questionsForSession() -> [QuizQuestion] {
        guard let cat = selectedCategory else { return [] }
        let pool = selectedMode == .deepSession
            ? categories.flatMap { $0.quizzes }
            : cat.quizzes
        let count = min(selectedMode.questionCount, pool.count)
        return Array(pool.shuffled().prefix(count))
    }

    func scenariosForSession() -> [Scenario] {
        guard let cat = selectedCategory else { return [] }
        let pool = selectedCategoryId == "mixed"
            ? categories.flatMap { $0.scenarios }
            : cat.scenarios
        let count = min(selectedMode.questionCount, pool.count)
        return Array(pool.shuffled().prefix(count))
    }

    func recordResult(score: Double) {
        progressManager.recordPracticeSession(
            score: score,
            categoryId: selectedCategoryId,
            mode: selectedMode
        )
    }
}
