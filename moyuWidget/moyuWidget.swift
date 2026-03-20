import SwiftUI
import WidgetKit

struct MoyuWidgetEntry: TimelineEntry {
    let date: Date
    let daysLeft: Int
    let isBonus: Bool
    let quoteText: String
    let language: AppLanguage

    var absoluteDays: Int { abs(daysLeft) }
}

struct MoyuWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MoyuWidgetEntry {
        MoyuWidgetEntry(
            date: Date(),
            daysLeft: 12345,
            isBonus: false,
            quoteText: "Work is for survival; 'slacking' is for living.",
            language: .english
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (MoyuWidgetEntry) -> Void) {
        completion(loadEntry(for: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MoyuWidgetEntry>) -> Void) {
        let now = Date()
        let entry = loadEntry(for: now)
        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: now)) ?? now.addingTimeInterval(86400)
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadEntry(for date: Date) -> MoyuWidgetEntry {
        let data = WidgetData.load()
        let calculator = CountdownCalculator()
        let result = calculator.result(birthDate: data.birthDate, sex: data.sex, referenceDate: date)
        let quote = DailyQuoteProvider().quote(for: date).text(for: data.language)

        return MoyuWidgetEntry(
            date: date,
            daysLeft: result.daysLeft,
            isBonus: result.isBonus,
            quoteText: quote,
            language: data.language
        )
    }
}

struct MoyuWidgetView: View {
    let entry: MoyuWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(titleText)
                    .font(.caption)
                    .foregroundStyle(accentColor)
                Text("\(entry.absoluteDays)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(accentColor)
                Text(unitText)
                    .font(.headline)
                    .foregroundStyle(accentColor)
            }

            Text(entry.quoteText)
                .font(.footnote)
                .foregroundStyle(.primary)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
        }
        .padding(16)
        .containerBackground(LinearGradient(
            colors: [Color(red: 0.96, green: 0.97, blue: 0.99), Color(red: 0.91, green: 0.93, blue: 0.98)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ), for: .widget)
    }

    private var titleText: String {
        entry.isBonus ? localized("bonus_title") : localized("days_left_title")
    }

    private var unitText: String {
        localized("days_unit")
    }

    private var accentColor: Color {
        entry.isBonus ? Color(red: 0.18, green: 0.55, blue: 0.38) : Color(red: 0.78, green: 0.29, blue: 0.18)
    }

    private func localized(_ key: String) -> String {
        switch entry.language {
        case .english:
            return english(key)
        case .simplifiedChinese:
            return chinese(key)
        case .spanish:
            return spanish(key)
        case .japanese:
            return japanese(key)
        }
    }

    private func english(_ key: String) -> String {
        switch key {
        case "days_left_title": return "Days Left"
        case "bonus_title": return "Bonus Days"
        case "days_unit": return "Days"
        default: return ""
        }
    }

    private func chinese(_ key: String) -> String {
        switch key {
        case "days_left_title": return "剩余天数"
        case "bonus_title": return "赚到的天数"
        case "days_unit": return "天"
        default: return ""
        }
    }

    private func spanish(_ key: String) -> String {
        switch key {
        case "days_left_title": return "Días restantes"
        case "bonus_title": return "Días extra"
        case "days_unit": return "Días"
        default: return ""
        }
    }

    private func japanese(_ key: String) -> String {
        switch key {
        case "days_left_title": return "残り日数"
        case "bonus_title": return "ボーナス日数"
        case "days_unit": return "日"
        default: return ""
        }
    }
}

struct MoyuWidget: Widget {
    let kind: String = "moyuWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MoyuWidgetProvider()) { entry in
            MoyuWidgetView(entry: entry)
        }
        .configurationDisplayName("Quiet Quitting Today")
        .description("Days left and today's quote.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct MoyuWidgetBundle: WidgetBundle {
    var body: some Widget {
        MoyuWidget()
    }
}

private struct WidgetData {
    let birthDate: Date
    let sex: BiologicalSex
    let language: AppLanguage

    static func load() -> WidgetData {
        let defaults = SharedDefaults.userDefaults

        let language = AppLanguage(rawValue: defaults.string(forKey: SharedDefaults.Keys.language) ?? "") ?? AppLanguage.resolvedDefault()
        let sex = BiologicalSex(rawValue: defaults.string(forKey: SharedDefaults.Keys.sex) ?? "") ?? .male

        let birthDate: Date
        if defaults.object(forKey: SharedDefaults.Keys.birthDate) != nil {
            birthDate = Date(timeIntervalSince1970: defaults.double(forKey: SharedDefaults.Keys.birthDate))
        } else {
            var components = DateComponents()
            components.year = 1990
            components.month = 1
            components.day = 1
            components.calendar = Calendar(identifier: .gregorian)
            birthDate = components.date ?? Date(timeIntervalSince1970: 631152000)
        }

        return WidgetData(birthDate: birthDate, sex: sex, language: language)
    }
}
