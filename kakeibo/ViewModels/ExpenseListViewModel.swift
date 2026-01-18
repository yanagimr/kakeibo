import Combine
import Foundation

final class ExpenseListViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []

    private let store: ExpenseStore
    private static let monthlyHeaderFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter
    }()
    private let calendar: Calendar
    private let dateProvider: () -> Date

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
        return expenses
            .filter { $0.date >= interval.start && $0.date < interval.end }
            .reduce(0) { $0 + $1.amount }
    }

    func monthlyDateRangeText() -> String {
        guard let interval = calendar.dateInterval(of: .month, for: dateProvider()) else {
            return ""
        }
        return Self.monthlyHeaderFormatter.string(from: interval.start)
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

    private static func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }
}
