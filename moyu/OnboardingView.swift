import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var step: Step = .profile
    @State private var showingDeniedAlert = false

    private enum Step: Int, CaseIterable {
        case profile
        case language
        case notifications

        var titleKey: LocalizedStringKey {
            switch self {
            case .profile:
                return LocalizedStringKey("onboarding.profile.title")
            case .language:
                return LocalizedStringKey("onboarding.language.title")
            case .notifications:
                return LocalizedStringKey("onboarding.notifications.title")
            }
        }
    }

    private var nextButtonTitle: LocalizedStringKey {
        step == .notifications ? LocalizedStringKey("button.get-started") : LocalizedStringKey("button.next")
    }

    private var birthDateBounds: ClosedRange<Date> {
        DateBounds.birthdate()
    }

    var body: some View {
        VStack(spacing: 32) {
            TabView(selection: $step) {
                profileStep
                    .tag(Step.profile)
                languageStep
                    .tag(Step.language)
                notificationsStep
                    .tag(Step.notifications)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))

            VStack(spacing: 16) {
                Button(action: advance) {
                    Text(nextButtonTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .foregroundStyle(.white)
                }

                if step != .profile {
                    Button(action: goBack) {
                        Text("button.back")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 24)
        .background(Color(.systemBackground).ignoresSafeArea())
        .alert("settings.notifications.denied.title", isPresented: $showingDeniedAlert) {
            Button("button.ok", role: .cancel) {}
        } message: {
            Text("settings.notifications.denied.message")
        }
    }

    private var languageStep: some View {
        VStack(spacing: 16) {
            Text(Step.language.titleKey)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            Text("onboarding.language.subtitle")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Picker("onboarding.language.title", selection: $appState.selectedLanguage) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
    }

    private var profileStep: some View {
        VStack(spacing: 16) {
            Text(Step.profile.titleKey)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            Text("onboarding.profile.subtitle")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Picker("settings.profile.sex", selection: $appState.biologicalSex) {
                ForEach(BiologicalSex.allCases) { sex in
                    Text(sex.localizationKey).tag(sex)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            DatePicker(
                selection: $appState.birthDate,
                in: birthDateBounds,
                displayedComponents: .date
            ) {
                Text("settings.profile.birthdate")
            }
            .labelsHidden()
            .datePickerStyle(.wheel)
            .padding(.horizontal)
        }
    }

    private var notificationsStep: some View {
        VStack(spacing: 20) {
            Text(Step.notifications.titleKey)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("onboarding.notifications.subtitle")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                Task {
                    let granted = await appState.requestNotificationAuthorization()
                    if granted {
                        // State updated via AppState
                    } else {
                        showingDeniedAlert = true
                    }
                }
            } label: {
                Text("onboarding.notifications.allow")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal)

            if appState.notificationEnabled {
                Label("onboarding.notifications.enabled-status", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.callout)
                    .padding(.horizontal)
            }

            Text("onboarding.notifications.hint")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private func advance() {
        switch step {
        case .profile:
            step = .language
        case .language:
            step = .notifications
        case .notifications:
            completeOnboarding()
        }
    }

    private func goBack() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        step = previous
    }

    private func completeOnboarding() {
        appState.hasCompletedOnboarding = true
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
