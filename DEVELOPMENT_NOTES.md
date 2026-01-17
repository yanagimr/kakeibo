# 家計簿アプリ 開発メモ（MVPまでの流れ）

この文書は、今まで実装した内容を順を追って解説したメモです。後から設計や実装を見直すときの参考として使えます。

## 1. 設計の合意（単一の設計図）
- `DESIGN.md` を設計の単一の根拠（Single Source of Truth）にしました。
- 以後は「設計図が変わったらコードも変える」ルールで進めます。
- MVPは「支出のみ・今週合計・JSON保存・固定カテゴリ」という最小構成です。

## 2. プロジェクト構成の整理
- SwiftUIの雛形に、役割ごとのフォルダを追加しました。
  - `Models/`（データ構造）
  - `Stores/`（保存I/O）
  - `ViewModels/`（表示ロジック）
  - `Views/`（画面）
- Xcode側の `project.pbxproj` に新規ファイルを登録し、ビルド対象に追加しています。

## 3. モデルの追加
- `Category.swift`
  - 固定カテゴリ（食費・娯楽・家賃）を `enum` で定義。
  - `displayName` で日本語ラベルを提供。
- `Expense.swift`
  - 支出1件の構造体（id, date, amount, category, memo）。
  - JSON保存を想定して `Codable` にしています。
- `DayTotal.swift`
  - 将来のグラフ用データ構造（1日あたりの合計）。

## 4. JSON保存の追加
- `ExpenseStore.swift`
  - `load()` で `expenses.json` を読み込み。
  - `save()` で最新の配列を保存。
  - `JSONEncoder/Decoder` は `iso8601` の日付形式を使用。

### 技術ポイント
- `FileManager.default.urls(for:in:)` で Documents フォルダを取得。
- `.atomic` で安全に書き込み（途中失敗で壊れにくい）。

## 5. ViewModelの追加
- `ExpenseListViewModel.swift`
  - `@Published` の `expenses` が画面のデータ源。
  - `addExpense()` で追加→並び替え→保存。
  - `weeklyTotal()` で今週合計を返す。
  - `weeklyDayTotals()` で将来のグラフ用データを作成。

### 技術ポイント
- `Calendar` の `firstWeekday = 1` で日曜始まりに設定。
- `dateInterval(of:for:)` で「今週の範囲」を安全に計算。

## 6. 画面の追加
- `ExpenseListView.swift`
  - 今週合計と支出一覧を表示。
  - 右上の `+` で追加画面をモーダル表示。
- `AddExpenseView.swift`
  - 日付・金額・カテゴリ・メモを入力。
  - 金額が空や0なら保存ボタンを無効化。

## 7. 起動画面の差し替え
- `ContentView.swift` は `ExpenseListView` を表示するだけに変更。
- アプリ起動時に家計簿画面が表示されます。

## 8. 今の状態でできること
- 支出を追加してJSONに保存できる
- 支出一覧を確認できる
- 今週合計が日曜始まりで計算される

## 9. 次にやるなら（設計図に沿った追加）
- 週グラフ（Swift Charts）を追加
- カテゴリの追加編集
- 収入の追加
