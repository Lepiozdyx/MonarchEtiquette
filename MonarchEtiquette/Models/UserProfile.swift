import Foundation

struct UserProfile: Codable {
    var fullName: String
    var age: Int
    var primaryReasons: Set<PrimaryReason>
    var refinementGoals: Set<RefinementGoal>

    init() {
        fullName = ""
        age = 0
        primaryReasons = []
        refinementGoals = []
    }
}

enum PrimaryReason: String, Codable, CaseIterable, Identifiable {
    case selfDevelopment = "Personal self-development"
    case socialEvent = "Preparing for a social event"
    case professionalGrowth = "Professional growth"
    case confidence = "Improving confidence"
    case culturalEducation = "Cultural education"

    var id: String { rawValue }
}

enum RefinementGoal: String, Codable, CaseIterable, Identifiable {
    case diningEtiquette = "Improve dining etiquette"
    case socialConfidence = "Improve social confidence"
    case formalEvents = "Master formal event behavior"
    case dailyManners = "Strengthen daily manners"

    var id: String { rawValue }
}

struct SocietyRank {
    let level: Int
    let title: String
    let description: String
    let nextTitle: String

    static let ranks: [SocietyRank] = [
        SocietyRank(level: 1, title: "Novice", description: "Beginning the journey of refinement", nextTitle: "Refined"),
        SocietyRank(level: 2, title: "Refined", description: "Showing signs of elegance", nextTitle: "Cultured"),
        SocietyRank(level: 3, title: "Cultured", description: "Demonstrating consistent elegance", nextTitle: "Distinguished"),
        SocietyRank(level: 4, title: "Distinguished", description: "A paragon of refined conduct", nextTitle: "Royal"),
        SocietyRank(level: 5, title: "Royal", description: "The pinnacle of etiquette mastery", nextTitle: "Royal")
    ]

    static func rank(for graceScore: Int) -> SocietyRank {
        switch graceScore {
        case 0..<20: return ranks[0]
        case 20..<40: return ranks[1]
        case 40..<65: return ranks[2]
        case 65..<85: return ranks[3]
        default: return ranks[4]
        }
    }
}
