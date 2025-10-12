//
//  ContentView.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      DashboardView()
        .tabItem {
          Label("Deadlines", systemImage: "chart.bar.fill")
        }

      CategoriesView()
        .tabItem {
          Label("Categories", systemImage: "folder.fill")
        }

      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gear")
        }
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
}
