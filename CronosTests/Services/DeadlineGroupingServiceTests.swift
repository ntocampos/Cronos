//
//  DeadlineGroupingServiceTests.swift
//  CronosTests
//
//  Created by Assistant on 18/10/25.
//

import Foundation
import Testing

@testable import Cronos

@Suite("Deadline Grouping Service Tests")
struct DeadlineGroupingServiceTests {

  // MARK: - Test Data

  private var sampleDeadlines: [Deadline] {
    let workCategory = Category(name: "Work", colorHex: "#0066CC")
    let personalCategory = Category(name: "Personal", colorHex: "#00CC66")

    let now = Date()
    let calendar = Calendar.current

    return [
      Deadline(
        title: "Work Deadline 1",
        date: calendar.date(byAdding: .day, value: 5, to: now)!,
        category: workCategory
      ),
      Deadline(
        title: "Personal Task 1",
        date: calendar.date(byAdding: .day, value: 15, to: now)!,
        category: personalCategory
      ),
      Deadline(
        title: "Work Deadline 2",
        date: calendar.date(byAdding: .month, value: 2, to: now)!,
        category: workCategory
      ),
      Deadline(
        title: "Uncategorized Task",
        date: calendar.date(byAdding: .month, value: 8, to: now)!,
        category: nil
      ),
    ]
  }

  // MARK: - Tests

  @Test("Group by All returns single group")
  func groupByAllReturnsSingleGroup() {
    let deadlines = sampleDeadlines
    let groups = DeadlineGroupingService.groupDeadlines(deadlines, by: .all)

    #expect(groups.count == 1)
    #expect(groups.first?.title == "All Deadlines")
    #expect(groups.first?.deadlines.count == deadlines.count)
  }

  @Test("Group by Category creates correct categories")
  func groupByCategoryCreatesCorrectCategories() {
    let deadlines = sampleDeadlines
    let groups = DeadlineGroupingService.groupDeadlines(deadlines, by: .byCategory)

    #expect(groups.count == 3)  // Work, Personal, Uncategorized

    let categoryNames = Set(groups.map(\.title))
    #expect(categoryNames.contains("Work"))
    #expect(categoryNames.contains("Personal"))
    #expect(categoryNames.contains("Uncategorized"))
  }

  @Test("Group by Category sorts categories alphabetically")
  func groupByCategorySortsCategoriesAlphabetically() {
    let deadlines = sampleDeadlines
    let groups = DeadlineGroupingService.groupDeadlines(deadlines, by: .byCategory)

    let sortedTitles = groups.map(\.title)
    let expectedOrder = ["Personal", "Uncategorized", "Work"]

    #expect(sortedTitles == expectedOrder)
  }

  @Test("Group by Timeframe creates correct timeframes")
  func groupByTimeframeCreatesCorrectTimeframes() {
    let deadlines = sampleDeadlines
    let groups = DeadlineGroupingService.groupDeadlines(deadlines, by: .byTimeframe)

    // Should have "Next 30 days", "Next 6 months", and "Next year" groups
    #expect(groups.count == 3)

    let groupTitles = Set(groups.map(\.title))
    #expect(groupTitles.contains("Next 30 days"))
    #expect(groupTitles.contains("Next 6 months"))
    #expect(groupTitles.contains("Next year"))
  }

  @Test("Empty deadlines array returns empty groups")
  func emptyDeadlinesArrayReturnsEmptyGroups() {
    let emptyDeadlines: [Deadline] = []

    let allGroups = DeadlineGroupingService.groupDeadlines(emptyDeadlines, by: .all)
    #expect(allGroups.count == 1)
    #expect(allGroups.first?.deadlines.isEmpty == true)

    let categoryGroups = DeadlineGroupingService.groupDeadlines(emptyDeadlines, by: .byCategory)
    #expect(categoryGroups.isEmpty)

    let timeframeGroups = DeadlineGroupingService.groupDeadlines(emptyDeadlines, by: .byTimeframe)
    #expect(timeframeGroups.isEmpty)
  }
}
