//
//  CategorySortOrderMigration.swift
//  Cronos
//
//  Created by Claude Code on 11/11/25.
//

import Foundation
import SwiftData

@MainActor
struct CategorySortOrderMigration {
  private static let migrationKey = "HasMigratedCategorySortOrder"

  /// Checks if the migration has already been performed
  static var hasPerformedMigration: Bool {
    UserDefaults.standard.bool(forKey: migrationKey)
  }

  /// Marks the migration as complete
  private static func markMigrationComplete() {
    UserDefaults.standard.set(true, forKey: migrationKey)
  }

  /// Migrates existing categories to add sortOrder if they don't have one set
  /// This should be called once on app launch
  static func migrateIfNeeded(modelContext: ModelContext) {
    // Check if we've already performed this migration
    guard !hasPerformedMigration else {
      print("✓ Category sortOrder migration already completed")
      return
    }

    print("→ Starting category sortOrder migration...")

    do {
      // Fetch all categories sorted by name
      let fetchDescriptor = FetchDescriptor<Category>(
        sortBy: [SortDescriptor(\Category.name, order: .forward)]
      )

      let categories = try modelContext.fetch(fetchDescriptor)

      guard !categories.isEmpty else {
        print("✓ No categories to migrate")
        markMigrationComplete()
        return
      }

      // Assign sortOrder to any categories that have the default value (0)
      // or if all categories have 0, assign sequential order
      let needsMigration = categories.allSatisfy { $0.sortOrder == 0 }

      if needsMigration {
        for (index, category) in categories.enumerated() {
          category.sortOrder = index
          print("  Migrated category '\(category.name)' with sortOrder: \(index)")
        }

        try modelContext.save()
        print("✓ Successfully migrated \(categories.count) categories")
      } else {
        print("✓ Categories already have sortOrder values")
      }

      markMigrationComplete()
    } catch {
      print("✗ Failed to migrate categories: \(error)")
      // Don't mark as complete so it can retry next launch
    }
  }

  /// Force reset the migration flag (useful for testing)
  static func resetMigrationFlag() {
    UserDefaults.standard.removeObject(forKey: migrationKey)
    print("Reset migration flag")
  }
}
