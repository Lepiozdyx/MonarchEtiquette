import Foundation

@Observable
final class HomeViewModel {
    private let dataManager: DataManager
    private let progressManager: ProgressManager

    var todayAdvice: DailyAdvice?
    var featuredCategory: LessonCategory?

    init(dataManager: DataManager, progressManager: ProgressManager) {
        self.dataManager = dataManager
        self.progressManager = progressManager
        load()
    }

    var completedLessonsCount: Int { progressManager.completedLessonsCount }
    var currentStreak: Int { progressManager.currentStreak }

    private func load() {
        todayAdvice = dataManager.todayAdvice
        featuredCategory = dataManager.categories.first
    }
}
