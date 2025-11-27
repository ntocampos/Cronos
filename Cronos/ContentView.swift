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
      Tab("Overview", systemImage: "rectangle.grid.1x3") {
        DashboardView()
      }

      Tab("Categories", systemImage: "tag.fill") {
        CategoriesView()
      }

      Tab("Settings", systemImage: "gearshape") {
        SettingsView()
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
  @Previewable @State var coordinator = DeadlineCoordinator()

  ContentView()
    .sampleDataContainer()
    .environment(coordinator)
}
