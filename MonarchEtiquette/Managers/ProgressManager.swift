import Foundation

@Observable
final class ProgressManager {
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let completedLessons = "completedLessons"
        static let practiceSessionDates = "practiceSessionDates"
        static let metrics = "metrics"
        static let profile = "userProfile"
        static let lastStreakDate = "lastStreakDate"
        static let currentStreak = "currentStreak"
        static let totalScore = "totalScore"
    }

    private(set) var completedLessonIds: Set<String> = []
    private(set) var practiceSessionDates: [Date] = []
    private(set) var metrics: [String: Double] = [
        "Poise": 0.0, "Composure": 0.0, "Elegance": 0.0, "Consistency": 0.0
    ]
    private(set) var currentStreak: Int = 0
    private(set) var graceScore: Int = 0
    var profile: UserProfile = UserProfile()

    init() {
        load()
    }

    // MARK: - Lessons
    func markLessonCompleted(_ lessonId: String) {
        completedLessonIds.insert(lessonId)
        save()
        recalculateMetrics()
    }

    func isLessonCompleted(_ lessonId: String) -> Bool {
        completedLessonIds.contains(lessonId)
    }

    func isCategoryUnlocked(_ categoryId: String) -> Bool {
        let unlockedByDefault = ["dining", "social", "public"]
        if unlockedByDefault.contains(categoryId) { return true }
        return !completedLessonIds.isEmpty
    }

    var completedLessonsCount: Int { completedLessonIds.count }

    // MARK: - Practice Sessions
    func recordPracticeSession(score: Double, categoryId: String, mode: PracticeMode) {
        practiceSessionDates.append(Date())
        updateStreak()
        applyScoreToMetrics(score: score, categoryId: categoryId, mode: mode)
        save()
    }

    func sessionsThisWeek() -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        return practiceSessionDates.filter { $0 >= startOfWeek }
    }

    func hasPracticeSession(on weekday: Int) -> Bool {
        let sessions = sessionsThisWeek()
        return sessions.contains { Calendar.current.component(.weekday, from: $0) == weekday }
    }

    // MARK: - Streak
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = defaults.object(forKey: Keys.lastStreakDate) as? Date {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if daysDiff == 1 {
                currentStreak += 1
            } else if daysDiff > 1 {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        defaults.set(today, forKey: Keys.lastStreakDate)
        defaults.set(currentStreak, forKey: Keys.currentStreak)
    }

    // MARK: - Metrics & Grace Score
    private func applyScoreToMetrics(score: Double, categoryId: String, mode: PracticeMode) {
        let weight = score * (mode == .deepSession ? 0.15 : 0.10)

        switch categoryId {
        case "dining":
            metrics["Poise"] = min(1.0, (metrics["Poise"] ?? 0) + weight)
        case "social":
            metrics["Composure"] = min(1.0, (metrics["Composure"] ?? 0) + weight)
        case "formal", "public":
            metrics["Elegance"] = min(1.0, (metrics["Elegance"] ?? 0) + weight)
        case "professional":
            metrics["Consistency"] = min(1.0, (metrics["Consistency"] ?? 0) + weight)
        default:
            let increment = weight / 4.0
            metrics["Poise"] = min(1.0, (metrics["Poise"] ?? 0) + increment)
            metrics["Composure"] = min(1.0, (metrics["Composure"] ?? 0) + increment)
            metrics["Elegance"] = min(1.0, (metrics["Elegance"] ?? 0) + increment)
            metrics["Consistency"] = min(1.0, (metrics["Consistency"] ?? 0) + increment)
        }

        recalculateMetrics()
    }

    private func recalculateMetrics() {
        let lessonBonus = min(0.5, Double(completedLessonsCount) * 0.05)
        let avgMetric = metrics.values.reduce(0, +) / Double(metrics.count)
        graceScore = Int((avgMetric + lessonBonus) * 100)
        save()
    }

    // MARK: - Profile
    func saveProfile(_ updatedProfile: UserProfile) {
        profile = updatedProfile
        save()
    }

    // MARK: - Persistence
    private func save() {
        defaults.set(Array(completedLessonIds), forKey: Keys.completedLessons)
        defaults.set(practiceSessionDates, forKey: Keys.practiceSessionDates)
        defaults.set(metrics, forKey: Keys.metrics)
        defaults.set(graceScore, forKey: Keys.totalScore)

        if let encoded = try? JSONEncoder().encode(profile) {
            defaults.set(encoded, forKey: Keys.profile)
        }
    }

    private func load() {
        completedLessonIds = Set(defaults.stringArray(forKey: Keys.completedLessons) ?? [])
        practiceSessionDates = defaults.object(forKey: Keys.practiceSessionDates) as? [Date] ?? []
        metrics = defaults.dictionary(forKey: Keys.metrics) as? [String: Double] ?? [
            "Poise": 0.0, "Composure": 0.0, "Elegance": 0.0, "Consistency": 0.0
        ]
        currentStreak = defaults.integer(forKey: Keys.currentStreak)
        graceScore = defaults.integer(forKey: Keys.totalScore)

        if let data = defaults.data(forKey: Keys.profile),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            profile = decoded
        }
    }

    // MARK: - Debug reset
    func reset() {
        [Keys.completedLessons, Keys.practiceSessionDates, Keys.metrics,
         Keys.profile, Keys.lastStreakDate, Keys.currentStreak, Keys.totalScore].forEach {
            defaults.removeObject(forKey: $0)
        }
        load()
    }
}
