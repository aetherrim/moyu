import Combine
import Foundation
import SwiftUI
import UserNotifications
import WidgetKit

@MainActor
final class AppState: ObservableObject {
    @Published var selectedLanguage: AppLanguage {
        didSet {
            guard !isInitializing else { return }
            defaults.set(selectedLanguage.rawValue, forKey: SharedDefaults.Keys.language)
            refreshNotificationSchedule()
            refreshWidgets()
        }
    }

    @Published var biologicalSex: BiologicalSex {
        didSet {
            guard !isInitializing else { return }
            defaults.set(biologicalSex.rawValue, forKey: SharedDefaults.Keys.sex)
            refreshWidgets()
        }
    }

    @Published var birthDate: Date {
        didSet {
            guard !isInitializing else { return }
            defaults.set(birthDate.timeIntervalSince1970, forKey: SharedDefaults.Keys.birthDate)
            refreshWidgets()
        }
    }

    @Published var notificationEnabled: Bool {
        didSet {
            guard !isInitializing else { return }
            defaults.set(notificationEnabled, forKey: SharedDefaults.Keys.notificationEnabled)
            refreshNotificationSchedule()
        }
    }

    @Published var notificationTime: Date {
        didSet {
            guard !isInitializing else { return }
            defaults.set(notificationTime.timeIntervalSinceReferenceDate, forKey: SharedDefaults.Keys.notificationTime)
            refreshNotificationSchedule()
        }
    }

    @Published var hasCompletedOnboarding: Bool {
        didSet {
            guard !isInitializing else { return }
            defaults.set(hasCompletedOnboarding, forKey: SharedDefaults.Keys.hasCompletedOnboarding)
        }
    }

    @Published private(set) var lifeChecklistItems: [LifeChecklistItem] {
        didSet {
            guard !isInitializing else { return }
            saveLifeChecklistItems()
        }
    }

    private let defaults: UserDefaults
    private let notificationManager: NotificationManager
    private let dailyQuoteProvider: DailyQuoteProviding
    private let countdownCalculator: CountdownCalculator
    private var isInitializing: Bool = true
    private var notificationAuthorizationStatus: UNAuthorizationStatus = .notDetermined

    init(
        defaults: UserDefaults = SharedDefaults.userDefaults,
        notificationManager: NotificationManager = .shared,
        dailyQuoteProvider: DailyQuoteProviding = DailyQuoteProvider(),
        countdownCalculator: CountdownCalculator = CountdownCalculator()
    ) {
        SharedDefaults.migrateIfNeeded()
        self.defaults = defaults
        self.notificationManager = notificationManager
        self.dailyQuoteProvider = dailyQuoteProvider
        self.countdownCalculator = countdownCalculator

        let storedLanguage = defaults.string(forKey: SharedDefaults.Keys.language)
        self.selectedLanguage = AppLanguage(rawValue: storedLanguage ?? "") ?? AppLanguage.resolvedDefault()

        if let storedSex = defaults.string(forKey: SharedDefaults.Keys.sex), let sex = BiologicalSex(rawValue: storedSex) {
            self.biologicalSex = sex
        } else {
            self.biologicalSex = .male
        }

        if defaults.object(forKey: SharedDefaults.Keys.birthDate) != nil {
            let timestamp = defaults.double(forKey: SharedDefaults.Keys.birthDate)
            self.birthDate = Date(timeIntervalSince1970: timestamp)
        } else {
            var components = DateComponents()
            components.year = 1990
            components.month = 1
            components.day = 1
            components.calendar = Calendar(identifier: .gregorian)
            self.birthDate = components.date ?? Date(timeIntervalSince1970: 631152000) // 1990-01-01
        }

        if defaults.object(forKey: SharedDefaults.Keys.notificationTime) != nil {
            let time = defaults.double(forKey: SharedDefaults.Keys.notificationTime)
            self.notificationTime = Date(timeIntervalSinceReferenceDate: time)
        } else {
            self.notificationTime = Self.defaultNotificationTime
        }

        if defaults.object(forKey: SharedDefaults.Keys.notificationEnabled) != nil {
            self.notificationEnabled = defaults.bool(forKey: SharedDefaults.Keys.notificationEnabled)
        } else {
            self.notificationEnabled = true
        }

        self.hasCompletedOnboarding = defaults.bool(forKey: SharedDefaults.Keys.hasCompletedOnboarding)
        self.lifeChecklistItems = Self.loadLifeChecklistItems(from: defaults)

        self.isInitializing = false

        Task { @MainActor in
            await configureNotificationsOnLaunch()
        }
    }

    var locale: Locale { selectedLanguage.locale }

    var dailyQuote: Quote { quote() }

    var totalLifeChecklistCount: Int { lifeChecklistItems.count }

    var completedLifeChecklistCount: Int {
        lifeChecklistItems.lazy.filter(\.isCompleted).count
    }

    var lifeChecklistProgressText: String {
        "\(completedLifeChecklistCount)/\(totalLifeChecklistCount)"
    }

    var sortedLifeChecklistItems: [LifeChecklistItem] {
        lifeChecklistItems.sorted { lhs, rhs in
            if lhs.isCompleted != rhs.isCompleted {
                return !lhs.isCompleted && rhs.isCompleted
            }

            if lhs.sortOrder != rhs.sortOrder {
                return lhs.sortOrder < rhs.sortOrder
            }

            return lhs.createdAt < rhs.createdAt
        }
    }

    func quote(for date: Date = Date()) -> Quote {
        dailyQuoteProvider.quote(for: date)
    }

    func addLifeChecklistItem(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let nextSortOrder = (lifeChecklistItems.map(\.sortOrder).max() ?? -1) + 1
        lifeChecklistItems.append(
            LifeChecklistItem(
                title: trimmedTitle,
                sortOrder: nextSortOrder
            )
        )
    }

    func toggleLifeChecklistItemCompletion(id: UUID) {
        guard let index = lifeChecklistItems.firstIndex(where: { $0.id == id }) else { return }

        lifeChecklistItems[index].isCompleted.toggle()
        lifeChecklistItems[index].completedAt = lifeChecklistItems[index].isCompleted ? Date() : nil
    }

    func deleteLifeChecklistItems(at offsets: IndexSet) {
        let idsToDelete = offsets.map { sortedLifeChecklistItems[$0].id }
        lifeChecklistItems.removeAll { idsToDelete.contains($0.id) }
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

    func refreshNotificationsFromBackground() async {
        await updateNotificationAuthorizationStatus()
        refreshNotificationSchedule()
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
    static var defaultNotificationTime: Date {
        var components = DateComponents()
        components.hour = 10
        components.minute = 0
        components.second = 0
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone.current
        return components.date ?? Date()
    }

    func refreshWidgets() {
        WidgetCenter.shared.reloadTimelines(ofKind: "moyuWidget")
    }

    static func loadLifeChecklistItems(from defaults: UserDefaults) -> [LifeChecklistItem] {
        guard let data = defaults.data(forKey: SharedDefaults.Keys.lifeChecklistItems) else {
            return []
        }

        do {
            return try JSONDecoder().decode([LifeChecklistItem].self, from: data)
        } catch {
            return []
        }
    }

    func saveLifeChecklistItems() {
        do {
            let data = try JSONEncoder().encode(lifeChecklistItems)
            defaults.set(data, forKey: SharedDefaults.Keys.lifeChecklistItems)
        } catch {
            assertionFailure("Failed to save life checklist items: \(error)")
        }
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
