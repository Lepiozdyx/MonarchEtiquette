import Foundation

struct Scenario: Codable, Identifiable {
    let id: String
    let situation: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}
