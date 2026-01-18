import Combine
import Foundation

final class ExpenseListViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []

    private let store: ExpenseStore
    private let calendar: Calendar
    private let dateProvider: () -> Date
    private static let weeklyRangeStartFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter
    }()
    private static let weeklyRangeEndFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter
    }()

    init() {
        self.store = ExpenseStore()
        self.calendar = Self.makeCalendar()
        self.dateProvider = Date.init
        loadExpenses()
    }

    init(
        expenses: [Expense],
        store: ExpenseStore = ExpenseStore(),
        dateProvider: @escaping () -> Date,
        calendar: Calendar = ExpenseListViewModel.makeCalendar()
    ) {
        self.expenses = expenses
        self.store = store
        self.dateProvider = dateProvider
        self.calendar = calendar
        sortExpenses()
    }

    func addExpense(date: Date, amount: Int, category: Category, memo: String) {
        let expense = Expense(date: date, amount: amount, category: category, memo: memo)
        expenses.append(expense)
        sortExpenses()
        saveExpenses()
    }

    func monthlyTotal() -> Int {
        guard let interval = calendar.dateInterval(of: .month, for: dateProvider()) else {
            return 0
        }
        return total(in: interval)
    }

    func monthlyDateRangeText() -> String {
        guard let interval = calendar.dateInterval(of: .month, for: dateProvider()) else {
            return ""
        }
        return makeMonthlyHeaderFormatter().string(from: interval.start)
    }

    func weeklyTotal() -> Int {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: dateProvider()) else {
            return 0
        }
        return total(in: interval)
    }

    func weeklyDateRangeText() -> String {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: dateProvider()) else {
            return ""
        }
        guard let endDate = calendar.date(byAdding: .day, value: 6, to: interval.start) else {
            return ""
        }
        let startText = Self.weeklyRangeStartFormatter.string(from: interval.start)
        let endText = Self.weeklyRangeEndFormatter.string(from: endDate)
        return "\(startText)-\(endText)"
    }

    func monthlyDifference() -> Int {
        guard let current = calendar.dateInterval(of: .month, for: dateProvider()) else {
            return 0
        }
        guard let previousStart = calendar.date(byAdding: .month, value: -1, to: current.start),
              let previous = calendar.dateInterval(of: .month, for: previousStart) else {
            return 0
        }
        return total(in: current) - total(in: previous)
    }

    func weeklyDifference() -> Int {
        guard let current = calendar.dateInterval(of: .weekOfYear, for: dateProvider()) else {
            return 0
        }
        guard let previousStart = calendar.date(byAdding: .weekOfYear, value: -1, to: current.start),
              let previous = calendar.dateInterval(of: .weekOfYear, for: previousStart) else {
            return 0
        }
        return total(in: current) - total(in: previous)
    }

    private func loadExpenses() {
        do {
            expenses = try store.load()
            sortExpenses()
        } catch {
            expenses = []
        }
    }

    private func saveExpenses() {
        do {
            try store.save(expenses)
        } catch {
            return
        }
    }

    private func sortExpenses() {
        expenses.sort { $0.date > $1.date }
    }

    private func total(in interval: DateInterval) -> Int {
        expenses
            .filter { $0.date >= interval.start && $0.date < interval.end }
            .reduce(0) { $0 + $1.amount }
    }

    private static func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }

    private func makeMonthlyHeaderFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        formatter.timeZone = calendar.timeZone
        return formatter
    }
}
