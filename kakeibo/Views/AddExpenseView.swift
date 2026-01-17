import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var amountText = ""
    @State private var category: Category = .food
    @State private var memo = ""

    let onSave: (Date, Int, Category, String) -> Void

    private var amountValue: Int? {
        Int(amountText)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("日付") {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
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
        }
    }
}
