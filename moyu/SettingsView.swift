import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeniedAlert = false

    private var birthDateBounds: ClosedRange<Date> {
        DateBounds.birthdate()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("settings.profile.title")) {
                    Picker("settings.profile.sex", selection: $appState.biologicalSex) {
                        ForEach(BiologicalSex.allCases) { sex in
                            Text(sex.localizationKey).tag(sex)
                        }
                    }
                    .pickerStyle(.segmented)

                    DatePicker(
                        selection: $appState.birthDate,
                        in: birthDateBounds,
                        displayedComponents: .date
                    ) {
                        Text("settings.profile.birthdate")
                    }
                }

                Section(header: Text("settings.language.title")) {
                    Picker("settings.language.title", selection: $appState.selectedLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("settings.notifications.title")) {
                    Toggle(isOn: Binding(get: {
                        appState.notificationEnabled
                    }, set: { newValue in
                        handleNotificationToggle(newValue)
                    })) {
                        Text("settings.notifications.toggle")
                    }

                    if appState.notificationEnabled {
                        DatePicker(
                            selection: $appState.notificationTime,
                            displayedComponents: .hourAndMinute
                        ) {
                            Text("settings.notifications.time")
                        }
                        .datePickerStyle(.wheel)
                    }
                }

                Section(header: Text("settings.about.title"), footer: Text("settings.about.disclaimer")) {
                    Text("settings.about.source")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(Text("settings.title"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("button.done") { dismiss() }
                }
            }
            .alert("settings.notifications.denied.title", isPresented: $showingDeniedAlert) {
                Button("button.ok", role: .cancel) {}
            } message: {
                Text("settings.notifications.denied.message")
            }
        }
    }

    private func handleNotificationToggle(_ newValue: Bool) {
        guard newValue else {
            appState.notificationEnabled = false
            return
        }

        Task {
            let granted = await appState.requestNotificationAuthorization()
            if !granted {
                showingDeniedAlert = true
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
