import Foundation

struct AppContent: Codable {
    let dailyAdvice: [DailyAdvice]
    let categories: [LessonCategory]
}

struct DailyAdvice: Codable, Identifiable {
    let id: String
    let tip: String
    let sfSymbol: String
}

struct LessonCategory: Codable, Identifiable, Hashable {
    public static func == (lhs: LessonCategory, rhs: LessonCategory) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let sfSymbol: String
    let lessons: [Lesson]
    let quizzes: [QuizQuestion]
    let scenarios: [Scenario]
}
