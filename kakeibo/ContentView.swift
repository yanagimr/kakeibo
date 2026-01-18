//
//  ContentView.swift
//  kakeibo
//
//  Created by work on 2026/01/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExpenseListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("支出一覧")
                }
            GoalSettingsView()
                .tabItem {
                    Image(systemName: "flag")
                    Text("目標")
                }
            GraphView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("グラフ")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
