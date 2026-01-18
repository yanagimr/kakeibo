
import Foundation

// Swiftでは関連する struct / class を同一ファイルに書くのは普通
// Javaより 「概念単位」重視

// 1日分のグラフデータ
struct GraphEntry: Identifiable {
    let id = UUID()
    let date: Date
    let totals: [Category: Int]

    var total: Int {
        totals.values.reduce(0, +)
    }
}

// 集計ロジック
final class GraphViewModel: ObservableObject {
    // @Published 自体は「どの View に通知するか」を一切知らない
    // 単に「変更があった」というイベントを流しているだけ
    @Published private(set) var expenses: [Expense] = []

    private let store: ExpenseStore
    private let calendar: Calendar
    private let dateProvider: () -> Date

    init() {
        self.store = ExpenseStore()
        self.calendar = Self.makeCalendar()
        self.dateProvider = Date.init
        loadExpenses()
    }

    // 1週間分のグラフ用データを返す
    func weeklyEntries() -> [GraphEntry] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: dateProvider()) else {
            return []
        }
        return (0..<7).compactMap { offset in
            // 「週の開始日から offset 日後の“その日”を求め、その日が始まる瞬間（00:00）を取得している」
            guard let day = calendar.date(byAdding: .day, value: offset, to: interval.start) else {
                return nil
            }
            let startOfDay = calendar.startOfDay(for: day)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                return nil
            }
            let totals = totals(in: DateInterval(start: startOfDay, end: endOfDay))
            return GraphEntry(date: startOfDay, totals: totals)
        }
    }

    func monthlyEntries() -> [GraphEntry] {
        guard let interval = calendar.dateInterval(of: .month, for: dateProvider()) else {
            return []
        }
        guard let dayRange = calendar.range(of: .day, in: .month, for: interval.start) else {
            return []
        }
        return dayRange.compactMap { day in
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start) else {
                return nil
            }
            let startOfDay = calendar.startOfDay(for: date)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                return nil
            }
            let totals = totals(in: DateInterval(start: startOfDay, end: endOfDay))
            return GraphEntry(date: startOfDay, totals: totals)
        }
    }

    private func totals(in interval: DateInterval) -> [Category: Int] {
        var totals = Dictionary(uniqueKeysWithValues: Category.allCases.map { ($0, 0) })
        for expense in expenses where expense.date >= interval.start && expense.date < interval.end {
            totals[expense.category, default: 0] += expense.amount
        }
        return totals
    }

    private func loadExpenses() {
        do {
            expenses = try store.load()
        } catch {
            expenses = []
        }
    }

    private static func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        // 週の開始を日曜に設定
        calendar.firstWeekday = 1
        return calendar
    }
}
