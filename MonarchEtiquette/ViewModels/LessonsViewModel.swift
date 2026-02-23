import Foundation

@Observable
final class LessonsViewModel {
    private let dataManager: DataManager
    private let progressManager: ProgressManager

    var categories: [LessonCategory] = []

    init(dataManager: DataManager, progressManager: ProgressManager) {
        self.dataManager = dataManager
        self.progressManager = progressManager
        categories = dataManager.categories
    }

    func isLessonCompleted(_ lessonId: String) -> Bool {
        progressManager.isLessonCompleted(lessonId)
    }

    func markLessonCompleted(_ lessonId: String) {
        progressManager.markLessonCompleted(lessonId)
    }

    func completedCount(in category: LessonCategory) -> Int {
        category.lessons.filter { progressManager.isLessonCompleted($0.id) }.count
    }
}
