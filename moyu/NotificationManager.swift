import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    private static let reminderIdentifier = "daily.reminder.notification"

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func notificationSettings() async -> UNNotificationSettings? {
        await center.notificationSettings()
    }

    func scheduleDailyNotification(at time: Date, language: AppLanguage, quoteProvider: DailyQuoteProviding) {
        let components = Self.timeComponents(from: time)
        scheduleDailyNotification(at: components, language: language, quoteProvider: quoteProvider, referenceDate: time)
    }

    func scheduleDailyNotification(
        at components: DateComponents,
        language: AppLanguage,
        quoteProvider: DailyQuoteProviding,
        referenceDate: Date = Date()
    ) {
        let content = UNMutableNotificationContent()
        content.title = Self.localizedTitle(for: language)
        let nextFireDate = Self.nextTriggerDate(from: components, referenceDate: referenceDate)
        let quote = quoteProvider.quote(for: nextFireDate)
        content.body = quote.text(for: language)
        content.sound = .default

        var finalComponents = components
        finalComponents.calendar = components.calendar ?? Calendar.current
        finalComponents.timeZone = components.timeZone ?? TimeZone.current

        let trigger = UNCalendarNotificationTrigger(dateMatching: finalComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Self.reminderIdentifier, content: content, trigger: trigger)

        center.removePendingNotificationRequests(withIdentifiers: [Self.reminderIdentifier])
        center.add(request) { error in
            if let error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }

    func cancelDailyNotification() {
        center.removePendingNotificationRequests(withIdentifiers: [Self.reminderIdentifier])
    }

    private static func timeComponents(from date: Date) -> DateComponents {
        var components = Calendar.current.dateComponents([.hour, .minute], from: date)
        components.second = 0
        components.calendar = Calendar.current
        components.timeZone = TimeZone.current
        return components
    }

    private static func nextTriggerDate(from components: DateComponents, referenceDate: Date) -> Date {
        var calendar = components.calendar ?? Calendar.current
        let timeZone = components.timeZone ?? TimeZone.current
        calendar.timeZone = timeZone

        var matchComponents = DateComponents()
        matchComponents.hour = components.hour
        matchComponents.minute = components.minute
        matchComponents.second = components.second ?? 0
        matchComponents.timeZone = timeZone

        return calendar.nextDate(
            after: referenceDate,
            matching: matchComponents,
            matchingPolicy: .nextTime,
            direction: .forward
        ) ?? referenceDate
    }

    private static func localizedTitle(for language: AppLanguage) -> String {
        NSLocalizedString("notification.title", comment: "")
    }
}
