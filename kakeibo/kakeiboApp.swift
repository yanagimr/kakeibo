//
//  kakeiboApp.swift
//  kakeibo
//
//  Created by work on 2026/01/17.
//

 
 // SwiftUIでは `@main` が付いた型がアプリの入口になります。`kakeiboApp.swift` の `kakeiboApp` に `@main` が付いているため、起動時にこの型の `body` が呼ばれます。その中の `WindowGroup` が最初の画面を作り、`ContentView()` が表示されます。

import SwiftUI

@main
struct kakeiboApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
//
//  kakeiboApp.swift
//  kakeibo
//
//  Created by work on 2026/01/17.
//

import SwiftUI

@main
struct kakeiboApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
