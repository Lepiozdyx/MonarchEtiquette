import SwiftUI

struct ContentView: View {
    @State private var dataManager = DataManager()
    @State private var progressManager = ProgressManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
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

#Preview {
    ContentView()
}
