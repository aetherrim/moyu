import BackgroundTasks
import SwiftUI

@main
struct moyuApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appState: AppState

    init() {
        let appState = AppState()
        _appState = StateObject(wrappedValue: appState)

        BackgroundRefreshManager.shared.configure(appState: appState)
        BackgroundRefreshManager.shared.schedule()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.locale, appState.locale)
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .background else { return }
            BackgroundRefreshManager.shared.schedule()
        }
    }
}
