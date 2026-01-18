import SwiftUI

struct GoalSettingsView: View {
    @AppStorage("monthlyGoalAmount") private var monthlyGoalAmount = ""
    @AppStorage("savingPurpose") private var savingPurpose = ""

    private var amountValue: Int? {
        Int(monthlyGoalAmount)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("支出上限目標") {
                    TextField("例: 50000", text: $monthlyGoalAmount)
                        .keyboardType(.numberPad)
                }

                Section("節約の目的（任意）") {
                    TextField("例: 旅行", text: $savingPurpose)
                }
            }
            .navigationTitle("目標")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        // AppStorageに自動反映されるため追加処理は不要
                    }
                    .disabled(amountValue == nil)
                }
            }
        }
    }
}

struct GoalSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalSettingsView()
    }
}
