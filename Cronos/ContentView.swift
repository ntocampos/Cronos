//
//  ContentView.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(DataContainer.self) private var dataContainer
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
    .onAppear {
      if !hasMigrated {
        CategorySortOrderMigration.migrateIfNeeded(modelContext: dataContainer.context)
        hasMigrated = true
      }
    }
  }
}

#Preview {
  ContentView()
    .sampleDataContainer()
}
