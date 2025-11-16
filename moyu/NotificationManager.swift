import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    private static let reminderIdentifier = "daily.reminder.notification"
    private static let schedulingWindowDays = 30

    private static func reminderIdentifier(for offset: Int) -> String {
        "\(reminderIdentifier).\(offset)"
    }

    private static func reminderIdentifiersToClear() -> [String] {
        [reminderIdentifier] + (0..<schedulingWindowDays).map { reminderIdentifier(for: $0) }
    }

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
        let nextFireDate = Self.nextTriggerDate(from: components, referenceDate: referenceDate)
        var calendar = components.calendar ?? Calendar.current
        calendar.timeZone = components.timeZone ?? TimeZone.current

        let identifiersToClear = Self.reminderIdentifiersToClear()
        center.removePendingNotificationRequests(withIdentifiers: identifiersToClear)

        for offset in 0..<Self.schedulingWindowDays {
            guard let fireDate = calendar.date(byAdding: .day, value: offset, to: nextFireDate) else { continue }

            let quote = quoteProvider.quote(for: fireDate)
            let content = UNMutableNotificationContent()
            content.title = Self.localizedTitle(for: language)
            content.body = quote.text(for: language)
            content.sound = .default

            var fireComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireDate)
            fireComponents.calendar = calendar
            fireComponents.timeZone = calendar.timeZone

            let trigger = UNCalendarNotificationTrigger(dateMatching: fireComponents, repeats: false)
            let identifier = Self.reminderIdentifier(for: offset)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request) { error in
                if let error {
                    print("Failed to schedule notification (\(identifier)): \(error)")
                }
            }
        }
    }

    func cancelDailyNotification() {
        center.removePendingNotificationRequests(withIdentifiers: Self.reminderIdentifiersToClear())
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
