import Foundation

final class ExpenseListViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []

    private let store = ExpenseStore()
    private static let weeklyRangeStartFormatter: DateFormatter = {
        let formatter = DateFormatweeklyRangeStartFormatterter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter
    }()
    private static let weeklyRangeEndFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter
    }()
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }

    init() {
        loadExpenses()
    }

    func addExpense(date: Date, amount: Int, category: Category, memo: String) {
        let expense = Expense(date: date, amount: amount, category: category, memo: memo)
        expenses.append(expense)
        sortExpenses()
        saveExpenses()
    }

    func weeklyTotal() -> Int {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
            return 0
        }
        return expenses
            .filter { interval.contains($0.date) }
            .reduce(0) { $0 + $1.amount }
    }

    func weeklyDateRangeText() -> String {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
            return ""
        }
        guard let endDate = calendar.date(byAdding: .day, value: 6, to: interval.start) else {
            return ""
        }
        let startText = Self.weeklyRangeStartFormatter.string(from: interval.start)
        let endText = Self.weeklyRangeEndFormatter.string(from: endDate)
        return "\(startText)-\(endText)"
    }

    func weeklyDayTotals() -> [DayTotal] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
            return []
        }
        return (0..<7).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: interval.start) else {
                return nil
            }
            let startOfDay = calendar.startOfDay(for: day)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                return nil
            }
            let total = expenses
                .filter { $0.date >= startOfDay && $0.date < endOfDay }
                .reduce(0) { $0 + $1.amount }
            return DayTotal(date: startOfDay, total: total)
        }
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
}
