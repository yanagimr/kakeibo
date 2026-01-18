import SwiftUI

struct ExpenseListView: View {
    @StateObject private var viewModel = ExpenseListViewModel()
    @State private var isPresentingAdd = false

    private static let sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter
    }()
    private static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }()

    private var groupedExpenses: [(date: Date, expenses: [Expense])] {
        let grouped = Dictionary(grouping: viewModel.expenses) { expense in
            Self.calendar.startOfDay(for: expense.date)
        }
        return grouped
            .map { key, value in
                let sorted = value.sorted { $0.date > $1.date }
                return (date: key, expenses: sorted)
            }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("今月の合計")
                            Text(viewModel.monthlyDateRangeText())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("¥\(viewModel.monthlyTotal())")
                            .bold()
                    }
                }

                Section("支出一覧") {
                    if viewModel.expenses.isEmpty {
                        Text("まだ支出がありません")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(Array(groupedExpenses.enumerated()), id: \.element.date) { groupIndex, group in
                                Text(Self.sectionDateFormatter.string(from: group.date))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .textCase(.none)
                            ForEach(Array(group.expenses.enumerated()), id: \.element.id) { index, expense in
                                VStack(spacing: 0) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(expense.category.displayName)
                                                .font(.headline)
                                            if !expense.memo.isEmpty {
                                                Text(expense.memo)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        Spacer()
                                        Text("¥\(expense.amount)")
                                            .font(.headline)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("家計簿")
            .toolbar {
                Button {
                    isPresentingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isPresentingAdd) {
                AddExpenseView { date, amount, category, memo in
                    viewModel.addExpense(date: date, amount: amount, category: category, memo: memo)
                }
            }
        }
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView()
    }
}
