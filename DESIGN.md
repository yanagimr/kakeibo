# 家計簿アプリ 設計図 (MVP)

この文書を設計の単一の根拠とします。内容を変更したら、コードも必ず合わせて更新します。

## 目的

- iOSアプリ（SwiftUI）
- 支出のみ（収入は扱わない）
- 今週の合計を表示（週の始まりは日曜）
  - 今週の合計を表示するページにいつからいつまでの期間なのかを明示する（例：20225/1/1-1/8）
- JSONでシンプルに保存
- カテゴリは固定：食費・娯楽・家賃
- グラフはMVP外だが、後から追加できる構造にする

## MVP機能

- 支出の追加（日時、金額Int、カテゴリ、メモ）
  - 基本的に当日に入力するが、前日より前も入力できるようにしたい。
  - 追加画面では当日の日付（例：2026/1/1）が入力されており、カレンダーマークを押すとカレンダーが表示されるようにしたい
- 支出一覧の表示（新しい順）
- 今週の合計表示

## データモデル

- Expense
  - id: UUID
  - date: Date
  - amount: Int
  - category: Category
  - memo: String
- Category（enum）
  - food
  - entertainment
  - rent

## 永続化

- `expenses.json` に支出を保存
- 読み書きは専用のStoreが担当
- UIはメモリ上の配列を正とする

## アーキテクチャ

- SwiftUI + 軽量MVVM
- Views:
  - ExpenseListView（メイン）
  - AddExpenseView（モーダル）
- ViewModel:
  - ExpenseListViewModel が読み込み、保存、並び替え、週合計を担当
- Store:
  - ExpenseStore がJSON I/Oを担当

## 今週合計のルール

- 週の始まりは日曜
- 今週に含まれる支出だけを合算

## 将来対応（MVP外）

- Swift Chartsで週グラフ
- カテゴリ追加
- 収入の対応
