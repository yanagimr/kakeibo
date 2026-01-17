import SwiftUI

struct ExpenseListView: View {
    @StateObject private var viewModel = ExpenseListViewModel()
    @State private var isPresentingAdd = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("今週の合計")
//                        Spacer()
                        Text("¥\(viewModel.weeklyTotal())")
                            .bold()
                    }
                }

                Section("支出一覧") {
                    if viewModel.expenses.isEmpty {
                        Text("まだ支出がありません")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.expenses) { expense in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(expense.category.displayName)
                                        .font(.headline)
                                    if !expense.memo.isEmpty {
                                        Text(expense.memo)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Text(Self.dateFormatter.string(from: expense.date))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("¥\(expense.amount)")
                                    .font(.headline)
                            }
                            .padding(.vertical, 4)
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
