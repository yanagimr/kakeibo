import Foundation

final class ExpenseStore {
    private let fileName = "expenses.json"

    func load() throws -> [Expense] {
        let url = try fileURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            return []
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Expense].self, from: data)
    }

    func save(_ expenses: [Expense]) throws {
        let url = try fileURL()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(expenses)
        try data.write(to: url, options: [.atomic])
    }

    private func fileURL() throws -> URL {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw CocoaError(.fileNoSuchFile)
        }
        return documents.appendingPathComponent(fileName)
    }
}
