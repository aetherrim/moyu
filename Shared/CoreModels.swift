import Foundation
import SwiftUI

enum AppLanguage: String, Identifiable, Codable, CaseIterable {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case spanish = "es"
    case japanese = "ja"

    static let orderedLanguages: [AppLanguage] = [.english, .simplifiedChinese, .spanish, .japanese]
    static let allCases: [AppLanguage] = orderedLanguages

    var id: String { rawValue }

    var locale: Locale { Locale(identifier: rawValue) }

    var displayName: LocalizedStringKey {
        switch self {
        case .english:
            return LocalizedStringKey("language.en")
        case .simplifiedChinese:
            return LocalizedStringKey("language.zh")
        case .spanish:
            return LocalizedStringKey("language.es")
        case .japanese:
            return LocalizedStringKey("language.ja")
        }
    }

    static func resolvedDefault() -> AppLanguage {
        for identifier in Locale.preferredLanguages {
            let lowercased = identifier.lowercased()
            if lowercased.contains("zh") {
                return .simplifiedChinese
            }
            if lowercased.contains("es") {
                return .spanish
            }
            if lowercased.contains("ja") {
                return .japanese
            }
            if lowercased.contains("en") {
                return .english
            }
        }
        return .english
    }

    func next() -> AppLanguage {
        guard let index = Self.orderedLanguages.firstIndex(of: self) else { return .english }
        let nextIndex = (index + 1) % Self.orderedLanguages.count
        return Self.orderedLanguages[nextIndex]
    }
}

enum BiologicalSex: String, CaseIterable, Identifiable, Codable {
    case male
    case female

    var id: String { rawValue }

    var localizationKey: LocalizedStringKey {
        switch self {
        case .male:
            return LocalizedStringKey("sex.male")
        case .female:
            return LocalizedStringKey("sex.female")
        }
    }
}

struct LifeExpectancyConfig {
    /// CDC 2022 life expectancy (years)
    private static let values: [BiologicalSex: Double] = [
        .male: 73.5,
        .female: 79.3
    ]

    static func expectancy(for sex: BiologicalSex) -> Double {
        values[sex] ?? 76.0
    }
}

struct CountdownResult {
    let daysLeft: Int
    let deathDate: Date

    var isBonus: Bool { daysLeft <= 0 }
    var absoluteDays: Int { abs(daysLeft) }
}

struct CountdownCalculator {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func result(birthDate: Date, sex: BiologicalSex, referenceDate: Date = Date()) -> CountdownResult {
        let expectancy = LifeExpectancyConfig.expectancy(for: sex)
        let wholeYears = Int(expectancy)
        let fractional = expectancy - Double(wholeYears)

        var deathDate = calendar.date(byAdding: DateComponents(year: wholeYears), to: birthDate) ?? birthDate
        let additionalDays = Int((fractional * 365.2425).rounded())
        deathDate = calendar.date(byAdding: .day, value: additionalDays, to: deathDate) ?? deathDate

        let startOfToday = calendar.startOfDay(for: referenceDate)
        let startOfDeath = calendar.startOfDay(for: deathDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfDeath)
        let daysLeft = components.day ?? 0

        return CountdownResult(daysLeft: daysLeft, deathDate: deathDate)
    }
}

enum DateBounds {
    static func birthdate() -> ClosedRange<Date> {
        let calendar = Calendar(identifier: .gregorian)
        let minDate = calendar.date(from: DateComponents(year: 1940, month: 1, day: 1)) ?? Date(timeIntervalSince1970: 0)
        let maxDate = Date()
        return minDate...maxDate
    }
}
