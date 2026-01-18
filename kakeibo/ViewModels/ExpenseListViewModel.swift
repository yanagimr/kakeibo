import Foundation

final class ExpenseListViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []

    private let store = ExpenseStore()
    private static let monthlyHeaderFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
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

    func monthlyTotal() -> Int {
        guard let interval = calendar.dateInterval(of: .month, for: Date()) else {
            return 0
        }
        return expenses
            .filter { interval.contains($0.date) }
            .reduce(0) { $0 + $1.amount }
    }

    func monthlyDateRangeText() -> String {
        guard let interval = calendar.dateInterval(of: .month, for: Date()) else {
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
}
