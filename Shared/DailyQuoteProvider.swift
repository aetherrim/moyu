import Foundation

protocol DailyQuoteProviding {
    func quote(for date: Date) -> Quote
}

final class DailyQuoteProvider: DailyQuoteProviding {
    private let repository: QuoteRepository
    private let calendar: Calendar
    private var cachedQuote: Quote?
    private var cachedDate: Date?

    init(repository: QuoteRepository = QuoteRepository(), calendar: Calendar = .current) {
        self.repository = repository
        self.calendar = calendar
    }

    func quote(for date: Date = Date()) -> Quote {
        let normalizedDate = calendar.startOfDay(for: date)

        if let cachedDate, let cachedQuote, calendar.isDate(cachedDate, inSameDayAs: normalizedDate) {
            return cachedQuote
        }

        let nextQuote = repository.quote(for: normalizedDate)
        cachedDate = normalizedDate
        cachedQuote = nextQuote
        return nextQuote
    }
}
