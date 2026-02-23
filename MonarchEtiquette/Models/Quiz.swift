import Foundation

struct QuizQuestion: Codable, Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctIndex: Int
}

enum PracticeMode: String, CaseIterable, Identifiable {
    case quickTest = "Quick Test"
    case deepSession = "Deep Session"
    case scenarioMode = "Scenario Mode"

    var id: String { rawValue }

    var questionCount: Int {
        switch self {
        case .quickTest: return 5
        case .deepSession: return 15
        case .scenarioMode: return 5
        }
    }

    var duration: String {
        switch self {
        case .quickTest: return "~3 min"
        case .deepSession: return "~10 min"
        case .scenarioMode: return "~5 min"
        }
    }

    var subtitle: String {
        switch self {
        case .quickTest: return "5 questions"
        case .deepSession: return "15 questions"
        case .scenarioMode: return "Real-world situations"
        }
    }

    var sfSymbol: String {
        switch self {
        case .quickTest: return "bolt.fill"
        case .deepSession: return "book.fill"
        case .scenarioMode: return "person.2.fill"
        }
    }
}
