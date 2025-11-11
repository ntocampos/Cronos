//
//  PreviewHelpers.swift
//  Cronos
//
//  Created by Assistant on 18/10/25.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - ModelContainer Preview Extension
extension ModelContainer {
  /// Creates a preview-only model container with sample data
  static var preview: ModelContainer {
    let container = try! ModelContainer(
      for: Deadline.self, Category.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    // Add sample data
    SampleData.addSampleData(to: container.mainContext)

    return container
  }

  /// Creates an empty preview-only model container
  static var emptyPreview: ModelContainer {
    try! ModelContainer(
      for: Deadline.self, Category.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
  }
}

// MARK: - Sample Data Helper
struct SampleData {
  static func addSampleData(to context: ModelContext) {
    // Create sample categories
    let workCategory = Category(
      name: "Work",
      colorHex: Category.DefaultColors.blue,
      sortOrder: 0
    )
    let personalCategory = Category(
      name: "Personal",
      colorHex: Category.DefaultColors.green,
      sortOrder: 1
    )
    let studyCategory = Category(
      name: "Study",
      colorHex: Category.DefaultColors.orange,
      sortOrder: 2
    )
    let urgentCategory = Category(
      name: "Urgent",
      colorHex: Category.DefaultColors.red,
      sortOrder: 3
    )

    // Insert categories
    context.insert(workCategory)
    context.insert(personalCategory)
    context.insert(studyCategory)
    context.insert(urgentCategory)

    // Create sample deadlines with various dates
    let sampleDeadlines = createSampleDeadlines(
      workCategory: workCategory,
      personalCategory: personalCategory,
      studyCategory: studyCategory,
      urgentCategory: urgentCategory
    )

    // Insert deadlines
    for deadline in sampleDeadlines {
      context.insert(deadline)
    }

    // Save the context
    try? context.save()
  }

  /// Creates sample categories only (useful for category-related previews)
  static func addSampleCategories(to context: ModelContext) {
    let categories = [
      Category(name: "Work", colorHex: Category.DefaultColors.blue, sortOrder: 0),
      Category(name: "Personal", colorHex: Category.DefaultColors.green, sortOrder: 1),
      Category(name: "Study", colorHex: Category.DefaultColors.orange, sortOrder: 2),
      Category(name: "Urgent", colorHex: Category.DefaultColors.red, sortOrder: 3),
      Category(name: "Health", colorHex: Category.DefaultColors.purple, sortOrder: 4),
      Category(name: "Finance", colorHex: Category.DefaultColors.yellow, sortOrder: 5),
    ]

    for category in categories {
      context.insert(category)
    }

    try? context.save()
  }

  /// Returns sample deadlines without inserting them into context (useful for pure presentation components)
  static func getDeadlines() -> [Deadline] {
    let workCategory = Category(
      name: "Work",
      colorHex: Category.DefaultColors.blue,
      sortOrder: 0
    )
    let personalCategory = Category(
      name: "Personal",
      colorHex: Category.DefaultColors.green,
      sortOrder: 1
    )
    let studyCategory = Category(
      name: "Study",
      colorHex: Category.DefaultColors.orange,
      sortOrder: 2
    )
    let urgentCategory = Category(
      name: "Urgent",
      colorHex: Category.DefaultColors.red,
      sortOrder: 3
    )

    return createSampleDeadlines(
      workCategory: workCategory,
      personalCategory: personalCategory,
      studyCategory: studyCategory,
      urgentCategory: urgentCategory
    )
  }

  /// Returns sample categories without inserting them into context
  static func getCategories() -> [Category] {
    return [
      Category(name: "Work", colorHex: Category.DefaultColors.blue, sortOrder: 0),
      Category(name: "Personal", colorHex: Category.DefaultColors.green, sortOrder: 1),
      Category(name: "Study", colorHex: Category.DefaultColors.orange, sortOrder: 2),
      Category(name: "Urgent", colorHex: Category.DefaultColors.red, sortOrder: 3),
      Category(name: "Health", colorHex: Category.DefaultColors.purple, sortOrder: 4),
      Category(name: "Finance", colorHex: Category.DefaultColors.yellow, sortOrder: 5),
    ]
  }

  // MARK: - Private Helper Methods

  private static func createSampleDeadlines(
    workCategory: Category,
    personalCategory: Category,
    studyCategory: Category,
    urgentCategory: Category
  ) -> [Deadline] {
    return [
      Deadline(
        title: "Project Presentation",
        notes: "Final presentation for Q4 project",
        date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
        category: workCategory
      ),
      Deadline(
        title: "Tax Filing",
        notes: "Submit annual tax return",
        date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
        category: personalCategory
      ),
      Deadline(
        title: "Assignment Due",
        notes: "SwiftUI advanced concepts essay",
        date: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
        category: studyCategory
      ),
      Deadline(
        title: "Doctor Appointment",
        notes: "Annual checkup",
        date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
        category: personalCategory
      ),
      Deadline(
        title: "Client Meeting",
        notes: "Quarterly review with main client",
        date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
        category: workCategory
      ),
      Deadline(
        title: "Emergency Task",
        notes: "Critical system maintenance",
        date: Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date(),
        category: urgentCategory
      ),
      Deadline(
        title: "Birthday Party",
        notes: "Sarah's surprise birthday party",
        date: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
        category: personalCategory
      ),
      Deadline(
        title: "Exam Preparation",
        notes: "Final exam for Advanced Swift course",
        date: Calendar.current.date(byAdding: .day, value: 21, to: Date()) ?? Date(),
        category: studyCategory
      ),
    ]
  }
}
