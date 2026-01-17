import Foundation

enum Category: String, CaseIterable, Codable, Identifiable {
    case food
    case entertainment
    case rent

    var id: String { rawValue }

    var displayName: String {
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
