import SwiftUI

@main
struct AlphaNumChildApp: App {
    @StateObject private var progress = ProgressStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(progress)
        }
    }
}
