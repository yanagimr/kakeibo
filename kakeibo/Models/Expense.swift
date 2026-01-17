import Foundation

struct Expense: Identifiable, Codable {
    let id: UUID
    let date: Date
    let amount: Int
    let category: Category
    let memo: String

    init(id: UUID = UUID(), date: Date, amount: Int, category: Category, memo: String) {
        self.id = id
        self.date = date
        self.amount = amount
        self.category = category
        self.memo = memo
    }
}
