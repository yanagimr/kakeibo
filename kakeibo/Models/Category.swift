import Foundation

// CaseIterable: allCasesで全カテゴリを列挙できる
// Codable: JSON保存/読み込みのため
// Identifiable: SwiftUIのForEachで扱うため
enum Category: String, CaseIterable, Codable, Identifiable {
    case food
    case entertainment
    case rent

    var id: String {
        get {
            return rawValue
        }
    }

    // 表示ラベルは日本語、保存値はrawValueで分離する（AddExpenseViewのPickerで使用）
    var displayName: String {
        get {
            switch self {
            case .food:
                return "食費"
            case .entertainment:
                return "娯楽"
            case .rent:
                return "家賃"
            }
        }
    }
}
