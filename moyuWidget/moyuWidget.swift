import SwiftUI
import WidgetKit

struct MoyuWidgetEntry: TimelineEntry {
    let date: Date
    let daysLeft: Int
    let isBonus: Bool
    let quoteText: String
    let language: AppLanguage
    let progress: Double

    var absoluteDays: Int { abs(daysLeft) }
}

struct MoyuWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MoyuWidgetEntry {
        MoyuWidgetEntry(
            date: Date(),
            daysLeft: 12345,
            isBonus: false,
            quoteText: "Work is for survival; 'slacking' is for living.",
            language: .english,
            progress: 0.42
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
        let progress = Self.lifeProgress(birthDate: data.birthDate, deathDate: result.deathDate, referenceDate: date)

        return MoyuWidgetEntry(
            date: date,
            daysLeft: result.daysLeft,
            isBonus: result.isBonus,
            quoteText: quote,
            language: data.language,
            progress: progress
        )
    }

    private static func lifeProgress(birthDate: Date, deathDate: Date, referenceDate: Date) -> Double {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: birthDate)
        let end = calendar.startOfDay(for: deathDate)
        let now = calendar.startOfDay(for: referenceDate)

        let totalDays = max(1, calendar.dateComponents([.day], from: start, to: end).day ?? 1)
        let elapsedDays = min(totalDays, max(0, calendar.dateComponents([.day], from: start, to: now).day ?? 0))
        return Double(elapsedDays) / Double(totalDays)
    }
}

struct MoyuWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: MoyuWidgetEntry

    var body: some View {
        Group {
            if family == .systemSmall {
                ZStack(alignment: .topLeading) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(accentColor.opacity(0.45))
                        .padding(.leading, 12)
                        .padding(.top, 10)

                    smallBody
                }
            } else {
                ZStack(alignment: .topLeading) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 22, weight: .light))
                        .foregroundStyle(accentColor.opacity(0.45))
                        .padding(.leading, 14)
                        .padding(.top, 12)

                    mediumBody
                }
            }
        }
        .containerBackground(for: .widget) {
            widgetBackground
        }
    }

    private var smallBody: some View {
        ZStack {
            Circle()
                .stroke(accentColor.opacity(0.15), lineWidth: 8)

            Circle()
                .trim(from: 0, to: CGFloat(entry.progress))
                .stroke(accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))

            Text("\(entry.absoluteDays)")
                .font(.system(size: 15, weight: .semibold, design: .serif))
                .foregroundStyle(accentColor)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }

    private var mediumBody: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(entry.absoluteDays)")
                    .font(.system(size: 36, weight: .semibold, design: .serif))
                    .foregroundStyle(accentColor)
                Text(unitText)
                    .font(.headline)
                    .foregroundStyle(accentColor)
            }

            ProgressBar(value: entry.progress, tint: accentColor)
                .frame(height: 3)
                .padding(.horizontal, 28)

            Text(entry.quoteText)
                .font(.footnote)
                .foregroundStyle(Color(red: 0.30, green: 0.30, blue: 0.35))
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
    }

    private var widgetBackground: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.94)

            RadialGradient(
                colors: [Color(red: 0.85, green: 0.80, blue: 0.93).opacity(0.6), .clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 240
            )

            RadialGradient(
                colors: [Color(red: 0.78, green: 0.90, blue: 0.85).opacity(0.5), .clear],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 220
            )

            RadialGradient(
                colors: [Color(red: 0.94, green: 0.84, blue: 0.86).opacity(0.35), .clear],
                center: UnitPoint(x: 0.8, y: 0.3),
                startRadius: 0,
                endRadius: 160
            )
        }
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

private struct ProgressBar: View {
    let value: Double
    let tint: Color

    var body: some View {
        GeometryReader { proxy in
            let width = max(0, min(proxy.size.width, proxy.size.width * CGFloat(value)))
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.06))
                Capsule()
                    .fill(tint)
                    .frame(width: width)
            }
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
