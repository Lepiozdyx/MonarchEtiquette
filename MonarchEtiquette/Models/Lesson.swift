import Foundation

struct Lesson: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let keyPoints: [String]
}
