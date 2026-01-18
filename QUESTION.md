### 質問
* Models、Preview, ViewModels, Storesは一般的な仕組みなのか
    * Models / ViewModels / Views はMVVMの考え方に沿った一般的な分割です。Storesは必須ではありませんが、保存や取得などI/Oを切り出す目的で実務でもよく使われます。PreviewはSwiftUI特有で、プレビュー用のデータや見た目をまとめる用途で使われます。
* Preview Contentとは何か
    * Preview ContentはXcodeが自動で作る「プレビュー専用のアセット置き場」です。SwiftUIのCanvasで使う画像などを入れる場所で、アプリ本体に必ず含める必要はありません。
* ViewModelsとViewの違いは何か
    * Viewは画面そのもの（見た目・UI配置）が役割です。ViewModelは画面の状態とロジック（読み込み、計算、並び替えなど）を持ち、Viewが表示しやすい形にデータを整える役割です。
* ContentViewって何？
    * SwiftUIアプリの最初の画面（ルートView）として使われることが多いファイル名です。`kakeiboApp.swift` の `WindowGroup` で `ContentView()` を呼んでいるので、アプリ起動時に最初に表示される画面になっています。プロジェクトによっては `ContentView` を別の画面に差し替えることも普通にあります。
*  今のプロジェクト構成は一般的なMVVMアーキテクチャに沿っているか？ContentView.swift、Preview.swiftなど、ルート直下のものがそこにあっていいのか気になる
    * 概ね一般的なMVVM構成です。`ContentView.swift` や `kakeiboApp.swift` のようなエントリーポイント/ルートViewは、プロジェクト直下に置かれることも多く、違和感はありません。`Previews.swift` も小規模プロジェクトなら直下で問題ありません。規模が大きくなったら `Views/` 配下に移動してもOKです。
* テストがUIテストとロジックのテストで別の場所に書かれているが、それはベストなのか？UIのテストよりロジックのテストを優先させるためにそうしているが、戦略として適切か
    * 一般的には、ロジックのテストは高速で安定しているため優先度が高く、UIテストは本数を絞って重要な導線のみを確認するのが良いバランスです。今回はロジックをSwiftPM側に切り出し `swift test` で素早く回し、UIテストは必要最低限にする方針は妥当です。
* 具体的に、どのコードによって、モジュールの分離ができているの？
    * `Package.swift` の `targets` 定義が分離の本体です。`KakeiboCore` ターゲットが `kakeibo` フォルダのコードをモジュールとして扱い、`exclude` でUI関連を外しています。さらに `Tests/KakeiboCoreTests/` がそのモジュール向けのテストターゲットです。
