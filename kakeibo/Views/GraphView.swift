import SwiftUI

struct GraphView: View {
    private enum Period: String, CaseIterable, Identifiable {
        case week = "週"
        case month = "月"

        var id: String { rawValue }
    }

    // GraphViewModelからの通知を監視
    @StateObject private var viewModel = GraphViewModel()
    @State private var period: Period = .week

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter
    }()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("期間", selection: $period) {
                    ForEach(Period.allCases) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if period == .week {
                    GraphBarsView(entries: viewModel.weeklyEntries(), labelFormat: .short)
                } else {
                    GraphBarsView(entries: viewModel.monthlyEntries(), labelFormat: .dayOnly)
                }
            }
            .padding(.vertical, 8)
            .navigationTitle("グラフ")
        }
    }
}

private enum GraphLabelFormat {
    case short
    case dayOnly
}

private struct GraphBarsView: View {
    let entries: [GraphEntry]
    let labelFormat: GraphLabelFormat

    private let maxBarHeight: CGFloat = 140

    private var maxTotal: Int {
        max(entries.map(\.total).max() ?? 0, 1)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(entries) { entry in
                    VStack(spacing: 6) {
                        StackedBarView(entry: entry, maxTotal: maxTotal, maxBarHeight: maxBarHeight)
                        Text(label(for: entry.date))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    private func label(for date: Date) -> String {
        switch labelFormat {
        case .short:
            return Self.shortFormatter.string(from: date)
        case .dayOnly:
            return Self.dayFormatter.string(from: date)
        }
    }

    private static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}

private struct StackedBarView: View {
    let entry: GraphEntry
    let maxTotal: Int
    let maxBarHeight: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Category.allCases, id: \.self) { category in
                barSegment(for: category)
            }
        }
        .frame(width: 18, height: maxBarHeight, alignment: .bottom)
        .background(Color.secondary.opacity(0.08))
        .cornerRadius(4)
    }

    private func barSegment(for category: Category) -> some View {
        let total = entry.totals[category, default: 0]
        let height = maxTotal == 0 ? 0 : CGFloat(total) / CGFloat(maxTotal) * maxBarHeight
        return Rectangle()
            .fill(color(for: category))
            .frame(height: height)
    }

    private func color(for category: Category) -> Color {
        switch category {
        case .food:
            return Color.orange
        case .entertainment:
            return Color.pink
        case .rent:
            return Color.blue
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
