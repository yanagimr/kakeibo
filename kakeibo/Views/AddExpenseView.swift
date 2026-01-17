import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var amountText = ""
    @State private var category: Category = .food
    @State private var memo = ""
    @State private var isPresentingDatePicker = false

    let onSave: (Date, Int, Category, String) -> Void

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter
    }()

    private var amountValue: Int? {
        Int(amountText)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("日付") {
                    HStack {
                        Text(Self.dateFormatter.string(from: date))
                        Spacer()
                        Button {
                            isPresentingDatePicker = true
                        } label: {
                            Image(systemName: "calendar")
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("カレンダーを開く")
                    }
                }

                Section("金額") {
                    TextField("例: 1200", text: $amountText)
                        .keyboardType(.numberPad)
                }

                Section("カテゴリ") {
                    Picker("カテゴリ", selection: $category) {
                        ForEach(Category.allCases) { category in
                            Text(category.displayName).tag(category) // UIは日本語、保存値はenumのrawValueで分離
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("メモ") {
                    TextField("例: ランチ", text: $memo)
                }
            }
            .navigationTitle("支出を追加")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        guard let amount = amountValue, amount > 0 else {
                            return
                        }
                        onSave(date, amount, category, memo)
                        dismiss()
                    }
                    .disabled(amountValue == nil || amountValue == 0)
                }
            }
            .sheet(isPresented: $isPresentingDatePicker) {
                NavigationStack {
                    DatePicker("日付", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding(.horizontal)
                        .navigationTitle("日付を選択")
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("完了") {
                                    isPresentingDatePicker = false
                                }
                            }
                        }
                }
            }
        }
    }
}
