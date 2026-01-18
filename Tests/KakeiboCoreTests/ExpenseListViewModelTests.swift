import XCTest
@testable import KakeiboCore

final class ExpenseListViewModelTests: XCTestCase {
    func testMonthlyTotalOnlyCountsCurrentMonth() {
        let calendar = Self.makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 1, day: 15))!
        let expenses = [
            Expense(date: calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!, amount: 100, category: .food, memo: ""),
            Expense(date: calendar.date(from: DateComponents(year: 2026, month: 1, day: 31))!, amount: 200, category: .rent, memo: ""),
            Expense(date: calendar.date(from: DateComponents(year: 2026, month: 2, day: 1))!, amount: 300, category: .entertainment, memo: "")
        ]

        let viewModel = ExpenseListViewModel(expenses: expenses, dateProvider: { now }, calendar: calendar)

        XCTAssertEqual(viewModel.monthlyTotal(), 300)
    }

    func testMonthlyDateRangeTextUsesYearMonthFormat() {
        let calendar = Self.makeCalendar()
        let now = calendar.date(from: DateComponents(year: 2026, month: 1, day: 10))!
        let viewModel = ExpenseListViewModel(expenses: [], dateProvider: { now }, calendar: calendar)

        XCTAssertEqual(viewModel.monthlyDateRangeText(), "2026年1月")
    }

    private static func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 9 * 3600) ?? .current
        calendar.firstWeekday = 1
        return calendar
    }
}
