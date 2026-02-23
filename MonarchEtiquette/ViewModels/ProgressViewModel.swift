import Foundation

@Observable
final class ProgressViewModel {
    private let progressManager: ProgressManager

    init(progressManager: ProgressManager) {
        self.progressManager = progressManager
    }

    var graceScore: Int { progressManager.graceScore }
    var currentStreak: Int { progressManager.currentStreak }
    var metrics: [String: Double] { progressManager.metrics }

    var graceScoreSubtitle: String {
        switch graceScore {
        case 0..<20: return "Begin your journey to elegance"
        case 20..<40: return "Signs of refinement are emerging"
        case 40..<65: return "You're on the path to flawless elegance"
        case 65..<85: return "A paragon of refined conduct"
        default: return "You have achieved royal grace"
        }
    }

    var orderedMetrics: [(String, Double)] {
        ["Poise", "Composure", "Elegance", "Consistency"].compactMap { key in
            guard let value = metrics[key] else { return nil }
            return (key, value)
        }
    }

    func weeklyActivity() -> [(day: String, hasActivity: Bool)] {
        let days = [(2, "Mon"), (3, "Tue"), (4, "Wed"), (5, "Thu"), (6, "Fri"), (7, "Sat"), (1, "Sun")]
        return days.map { (weekday, label) in
            (label, progressManager.hasPracticeSession(on: weekday))
        }
    }
}
