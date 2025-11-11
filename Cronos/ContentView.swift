//
//  ContentView.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject private var themeManager: ThemeManager
  @State private var hasMigrated = false

  var body: some View {
    TabView {
      DashboardView()
        .tabItem {
          Label("Deadlines", systemImage: "chart.bar.fill")
        }

      GroupsView()
        .tabItem {
          Label("Groups", systemImage: "rectangle.3.group")
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
    .tint(themeManager.accent(for: colorScheme))
    .toolbarBackground(themeManager.primaryBackground(for: colorScheme), for: .tabBar)
    .toolbarBackground(.visible, for: .tabBar)
    .onAppear {
      if !hasMigrated {
        CategorySortOrderMigration.migrateIfNeeded(modelContext: modelContext)
        hasMigrated = true
      }
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
    .environmentObject(ThemeManager())
}
