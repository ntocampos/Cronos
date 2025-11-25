import Foundation
import SwiftUI

/// Represents a mode for grouping deadlines
enum GroupingMode {
  case none
  case byCategory
  case byTimeframe
}

/// Represents a group of deadlines with associated metadata
struct DeadlineGroup: Identifiable {
  let id = UUID()
  let title: String
  let deadlines: [Deadline]
  let color: Color?
  let maxDaysReference: Double?

  init(title: String, deadlines: [Deadline], color: Color? = nil, maxDaysReference: Double? = nil) {
    self.title = title
    self.deadlines = deadlines
    self.color = color
    self.maxDaysReference = maxDaysReference
  }
}

/// Service for grouping deadlines by various criteria
enum DeadlineGroupingService {

  /// Groups deadlines according to the specified grouping mode
  /// - Parameters:
  ///   - deadlines: The deadlines to group
  ///   - mode: The grouping mode to apply
  /// - Returns: An array of deadline groups
  static func groupDeadlines(_ deadlines: [Deadline], by mode: GroupingMode) -> [DeadlineGroup] {
    switch mode {
    case .none:
      let sortedDeadlines = deadlines.sorted { $0.date < $1.date }
      return [DeadlineGroup(title: "All Deadlines", deadlines: sortedDeadlines)]
    case .byCategory:
      return groupByCategory(deadlines)
    case .byTimeframe:
      return groupByTimeframe(deadlines)
    }
  }

  // MARK: - Private Grouping Methods

  private static func groupByCategory(_ deadlines: [Deadline]) -> [DeadlineGroup] {
    // Group deadlines by category (using UUID for unique grouping)
    let grouped = Dictionary(grouping: deadlines) { $0.category.id }

    // Get all categories with deadlines and sort by sortOrder
    let categorizedGroups =
      grouped
      .map { (_, groupDeadlines) -> (Category, [Deadline]) in
        // Category is guaranteed to exist since it's required on Deadline
        let category = groupDeadlines.first!.category
        return (category, groupDeadlines)
      }
      .sorted { $0.0.sortOrder < $1.0.sortOrder }

    // Create DeadlineGroup objects
    let groups = categorizedGroups.map { (category, groupDeadlines) in
      let sortedDeadlines = groupDeadlines.sorted { $0.date < $1.date }
      return DeadlineGroup(
        title: category.name,
        deadlines: sortedDeadlines,
        color: category.color,
        maxDaysReference: nil
      )
    }

    return groups
  }

  private static func groupByTimeframe(_ deadlines: [Deadline]) -> [DeadlineGroup] {
    var groups: [DeadlineGroup] = []

    // Define timeframes with their properties
    let timeframes: [(title: String, maxDays: Int, color: Color, range: ClosedRange<Int>)] = [
      ("Next 7 days", 7, .red, 0...7),
      ("Next 30 days", 30, .orange, 8...30),
      ("Next 6 months", 180, .yellow, 31...180),
      ("Next year", 365, .green, 181...365),
    ]

    // Group deadlines into timeframes
    for timeframe in timeframes {
      let filteredDeadlines = deadlines.filter { deadline in
        guard let daysUntil = deadline.daysUntil else { return false }
        return timeframe.range.contains(daysUntil)
      }

      // Only include groups that have deadlines
      if !filteredDeadlines.isEmpty {
        let sortedDeadlines = filteredDeadlines.sorted { $0.date < $1.date }
        groups.append(
          DeadlineGroup(
            title: timeframe.title,
            deadlines: sortedDeadlines,
            color: timeframe.color,
            maxDaysReference: Double(timeframe.maxDays)
          ))
      }
    }

    return groups
  }
}
