//
//  DataContainer.swift
//  Cronos
//
//  Created by Moisés Neto on 16/11/25.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
class DataContainer {
  let modelContainer: ModelContainer

  var context: ModelContext {
    modelContainer.mainContext
  }

  init(includeSampleMoments: Bool = false, isStoredInMemoryOnly: Bool = false) {
    let schema = Schema([
      Category.self,
      Deadline.self,
    ])

    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: isStoredInMemoryOnly
    )

    do {
      modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

      if includeSampleMoments {
        loadSampleData()
      }

      ensureDefaultCategoryExists()

      try context.save()
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }

  func getDefaultCategory() -> Category? {
    guard let storedId = UserDefaults.standard.string(forKey: SettingsKeys.defaultCategoryId) else {
      return nil
    }

    let descriptor = FetchDescriptor<Category>()
    do {
      let categories = try context.fetch(descriptor)
      return categories.first { $0.id.uuidString == storedId }
    } catch {
      return nil
    }
  }

  private func ensureDefaultCategoryExists() {
    let descriptor = FetchDescriptor<Category>()

    do {
      let categories = try context.fetch(descriptor)

      // If no categories exist, create the "General" category
      var generalCategory: Category
      if categories.isEmpty {
        generalCategory = Category(
          name: "General",
          colorHex: Category.DefaultColors.blue,
          sortOrder: 0
        )
        context.insert(generalCategory)
      } else {
        // Use the first category as fallback for default
        generalCategory = categories.first!
      }

      // If no default category is set, set one
      let storedDefaultId = UserDefaults.standard.string(forKey: SettingsKeys.defaultCategoryId)
      if storedDefaultId == nil {
        UserDefaults.standard.set(
          generalCategory.id.uuidString, forKey: SettingsKeys.defaultCategoryId)
      } else {
        // Verify the stored default still exists
        let defaultExists = categories.contains { $0.id.uuidString == storedDefaultId }
        if !defaultExists {
          UserDefaults.standard.set(
            generalCategory.id.uuidString, forKey: SettingsKeys.defaultCategoryId)
        }
      }
    } catch {
      print("Error ensuring default category: \(error)")
    }
  }

  private func loadSampleData() {
    for category in Category.sampleData {
      context.insert(category)
    }

    for deadline in Deadline.sampleData {
      context.insert(deadline)
    }
  }
}

let sampleContainer = DataContainer(includeSampleMoments: true, isStoredInMemoryOnly: true)
let emptyContainer = DataContainer(isStoredInMemoryOnly: true)

extension View {
  func sampleDataContainer() -> some View {
    self
      .environment(sampleContainer)
      .modelContainer(sampleContainer.modelContainer)
  }

  func emptyDataContainer() -> some View {
    self.environment(emptyContainer)
      .modelContainer(emptyContainer.modelContainer)
  }
}
