import SwiftUI

@main
struct MonarchEtiquetteApp: App {
    @State private var dataManager = DataManager()
    @State private var progressManager = ProgressManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environment(dataManager)
                    .environment(progressManager)
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView()
            }
        }
    }
}
