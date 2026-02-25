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
        let pool: [QuizQuestion]
        if selectedCategoryId == "mixed" || selectedMode == .deepSession {
            pool = categories.flatMap { $0.quizzes }
        } else {
            guard let cat = selectedCategory else { return [] }
            pool = cat.quizzes
        }
        let count = min(selectedMode.questionCount, pool.count)
        return Array(pool.shuffled().prefix(count))
    }

    func scenariosForSession() -> [Scenario] {
        let pool: [Scenario]
        if selectedCategoryId == "mixed" {
            pool = categories.flatMap { $0.scenarios }
        } else {
            guard let cat = selectedCategory else { return [] }
            pool = cat.scenarios
        }
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
