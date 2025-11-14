import Combine
import SwiftUI

struct CountdownView: View {
    @EnvironmentObject private var appState: AppState
    @State private var now = Date()
    @State private var showingSettings = false

    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var countdown: CountdownResult {
        appState.countdownResult(referenceDate: now)
    }

    private var quoteText: String {
        appState.quote(for: now).text(for: appState.selectedLanguage)
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 24)

            VStack(spacing: 12) {
                Text(countdown.isBonus ? LocalizedStringKey("countdown.label.bonus") : LocalizedStringKey("countdown.label.remaining"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)

                Text("\(countdown.absoluteDays)")
                    .font(.system(size: 88, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: countdown.absoluteDays)
                    .accessibilityLabel(countdown.isBonus ? LocalizedStringKey("accessibility.bonus-days") : LocalizedStringKey("accessibility.days-left"))
            }
            .padding(.horizontal)

            Text(quoteText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .transition(.opacity)

            Spacer(minLength: 24)

            HStack(spacing: 24) {
                Button {
                    showingSettings = true
                } label: {
                    Label(LocalizedStringKey("button.settings"), systemImage: "gearshape")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .accessibilityLabel(LocalizedStringKey("accessibility.open-settings"))

                Button {
                    appState.toggleLanguage()
                } label: {
                    Label(LocalizedStringKey("button.language"), systemImage: "globe")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .accessibilityLabel(LocalizedStringKey("accessibility.toggle-language"))
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [.mint.opacity(0.2), .orange.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .onReceive(timer) { date in
            now = date
        }
        .onAppear {
            now = Date()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

#Preview {
    CountdownView()
        .environmentObject(AppState())
}
