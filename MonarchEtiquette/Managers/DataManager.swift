import Foundation

@Observable
final class DataManager {
    private(set) var appContent: AppContent?
    private(set) var categories: [LessonCategory] = []
    private(set) var dailyAdvice: [DailyAdvice] = []

    init() {
        loadContent()
    }

    private func loadContent() {
        guard let url = Bundle.main.url(forResource: "content", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }

        let decoder = JSONDecoder()
        guard let content = try? decoder.decode(AppContent.self, from: data) else { return }
        appContent = content
        categories = content.categories
        dailyAdvice = content.dailyAdvice
    }

    func category(id: String) -> LessonCategory? {
        categories.first { $0.id == id }
    }

    var todayAdvice: DailyAdvice? {
        guard !dailyAdvice.isEmpty else { return nil }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return dailyAdvice[dayOfYear % dailyAdvice.count]
    }
}
