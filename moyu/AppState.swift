import Combine
import Foundation
import SwiftUI
import UserNotifications

@MainActor
final class AppState: ObservableObject {
    @Published var selectedLanguage: AppLanguage {
        didSet {
            guard !isInitializing else { return }
            defaults.set(selectedLanguage.rawValue, forKey: Keys.language)
            refreshNotificationSchedule()
        }
    }

    @Published var biologicalSex: BiologicalSex {
        didSet {
            guard !isInitializing else { return }
            defaults.set(biologicalSex.rawValue, forKey: Keys.sex)
        }
    }

    @Published var birthDate: Date {
        didSet {
            guard !isInitializing else { return }
            defaults.set(birthDate.timeIntervalSince1970, forKey: Keys.birthDate)
        }
    }

    @Published var notificationEnabled: Bool {
        didSet {
            guard !isInitializing else { return }
            defaults.set(notificationEnabled, forKey: Keys.notificationEnabled)
            refreshNotificationSchedule()
        }
    }

    @Published var notificationTime: Date {
        didSet {
            guard !isInitializing else { return }
            defaults.set(notificationTime.timeIntervalSinceReferenceDate, forKey: Keys.notificationTime)
            refreshNotificationSchedule()
        }
    }

    @Published var hasCompletedOnboarding: Bool {
        didSet {
            guard !isInitializing else { return }
            defaults.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding)
        }
    }

    private let defaults: UserDefaults
    private let notificationManager: NotificationManager
    private let dailyQuoteProvider: DailyQuoteProviding
    private let countdownCalculator: CountdownCalculator
    private var isInitializing: Bool = true
    private var notificationAuthorizationStatus: UNAuthorizationStatus = .notDetermined

    init(
        defaults: UserDefaults = .standard,
        notificationManager: NotificationManager = .shared,
        dailyQuoteProvider: DailyQuoteProviding = DailyQuoteProvider(),
        countdownCalculator: CountdownCalculator = CountdownCalculator()
    ) {
        self.defaults = defaults
        self.notificationManager = notificationManager
        self.dailyQuoteProvider = dailyQuoteProvider
        self.countdownCalculator = countdownCalculator

        let storedLanguage = defaults.string(forKey: Keys.language)
        self.selectedLanguage = AppLanguage(rawValue: storedLanguage ?? "") ?? AppLanguage.resolvedDefault()

        if let storedSex = defaults.string(forKey: Keys.sex), let sex = BiologicalSex(rawValue: storedSex) {
            self.biologicalSex = sex
        } else {
            self.biologicalSex = .male
        }

        if defaults.object(forKey: Keys.birthDate) != nil {
            let timestamp = defaults.double(forKey: Keys.birthDate)
            self.birthDate = Date(timeIntervalSince1970: timestamp)
        } else {
            var components = DateComponents()
            components.year = 1990
            components.month = 1
            components.day = 1
            components.calendar = Calendar(identifier: .gregorian)
            self.birthDate = components.date ?? Date(timeIntervalSince1970: 631152000) // 1990-01-01
        }

        if defaults.object(forKey: Keys.notificationTime) != nil {
            let time = defaults.double(forKey: Keys.notificationTime)
            self.notificationTime = Date(timeIntervalSinceReferenceDate: time)
        } else {
            self.notificationTime = Self.defaultNotificationTime
        }

        if defaults.object(forKey: Keys.notificationEnabled) != nil {
            self.notificationEnabled = defaults.bool(forKey: Keys.notificationEnabled)
        } else {
            self.notificationEnabled = true
        }

        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)

        self.isInitializing = false

        Task { @MainActor in
            await configureNotificationsOnLaunch()
        }
    }

    var locale: Locale { selectedLanguage.locale }

    var dailyQuote: Quote { quote() }

    func quote(for date: Date = Date()) -> Quote {
        dailyQuoteProvider.quote(for: date)
    }

    func toggleLanguage() {
        selectedLanguage = selectedLanguage.next()
    }

    func countdownResult(referenceDate: Date = Date()) -> CountdownResult {
        countdownCalculator.result(birthDate: birthDate, sex: biologicalSex, referenceDate: referenceDate)
    }

    func requestNotificationAuthorization() async -> Bool {
        let granted = await notificationManager.requestAuthorization()
        await updateNotificationAuthorizationStatus()
        notificationEnabled = granted
        return granted
    }

    private func refreshNotificationSchedule() {
        guard !isInitializing else { return }
        guard notificationEnabled else {
            notificationManager.cancelDailyNotification()
            return
        }

        guard hasNotificationPermission else {
            notificationManager.cancelDailyNotification()
            return
        }

        var components = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        components.second = 0
        components.calendar = Calendar.current
        components.timeZone = TimeZone.current
        notificationManager.scheduleDailyNotification(
            at: components,
            language: selectedLanguage,
            quoteProvider: dailyQuoteProvider
        )
    }
}

private extension AppState {
    enum Keys {
        static let language = "settings.language"
        static let sex = "settings.sex"
        static let birthDate = "settings.birthDate"
        static let notificationEnabled = "settings.notificationEnabled"
        static let notificationTime = "settings.notificationTime"
        static let hasCompletedOnboarding = "settings.onboardingComplete"
    }

    static var defaultNotificationTime: Date {
        var components = DateComponents()
        components.hour = 10
        components.minute = 0
        components.second = 0
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone.current
        return components.date ?? Date()
    }

    private func configureNotificationsOnLaunch() async {
        await updateNotificationAuthorizationStatus()

        if hasNotificationPermission {
            if notificationEnabled {
                refreshNotificationSchedule()
            } else {
                notificationManager.cancelDailyNotification()
            }
        } else {
            notificationManager.cancelDailyNotification()
            if notificationEnabled {
                notificationEnabled = false
            }
        }
    }

    private func updateNotificationAuthorizationStatus() async {
        let settings = await notificationManager.notificationSettings()
        notificationAuthorizationStatus = settings?.authorizationStatus ?? .notDetermined
    }

    private var hasNotificationPermission: Bool {
        switch notificationAuthorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }
}
