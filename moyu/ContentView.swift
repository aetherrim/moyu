import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            if appState.hasCompletedOnboarding {
                CountdownView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                OnboardingView()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.hasCompletedOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
