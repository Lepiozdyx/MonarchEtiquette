import SwiftUI

@main
struct MonarchEtiquetteApp: App {
    @State private var dataManager = DataManager()
    @State private var progressManager = ProgressManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(dataManager)
                .environment(progressManager)
                .preferredColorScheme(.dark)
        }
    }
}
