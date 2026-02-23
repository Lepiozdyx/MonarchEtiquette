import Foundation

@Observable
final class ProfileViewModel {
    private let progressManager: ProgressManager

    var fullName: String = ""
    var ageText: String = ""
    var selectedReasons: Set<PrimaryReason> = []
    var selectedGoals: Set<RefinementGoal> = []
    var showingSavedBanner = false

    init(progressManager: ProgressManager) {
        self.progressManager = progressManager
        loadProfile()
    }

    var graceScore: Int { progressManager.graceScore }

    var societyRank: SocietyRank { SocietyRank.rank(for: graceScore) }

    var rankProgress: Double {
        switch societyRank.level {
        case 1: return Double(graceScore) / 20.0
        case 2: return Double(graceScore - 20) / 20.0
        case 3: return Double(graceScore - 40) / 25.0
        case 4: return Double(graceScore - 65) / 20.0
        default: return 1.0
        }
    }

    func saveProfile() {
        var profile = UserProfile()
        profile.fullName = fullName
        profile.age = Int(ageText) ?? 0
        profile.primaryReasons = selectedReasons
        profile.refinementGoals = selectedGoals
        progressManager.saveProfile(profile)
        showingSavedBanner = true

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            showingSavedBanner = false
        }
    }

    func toggleReason(_ reason: PrimaryReason) {
        if selectedReasons.contains(reason) {
            selectedReasons.remove(reason)
        } else {
            selectedReasons.insert(reason)
        }
    }

    func toggleGoal(_ goal: RefinementGoal) {
        if selectedGoals.contains(goal) {
            selectedGoals.remove(goal)
        } else {
            selectedGoals.insert(goal)
        }
    }

    private func loadProfile() {
        let profile = progressManager.profile
        fullName = profile.fullName
        ageText = profile.age > 0 ? "\(profile.age)" : ""
        selectedReasons = profile.primaryReasons
        selectedGoals = profile.refinementGoals
    }
}
