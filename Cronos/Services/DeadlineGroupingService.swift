//
//  DeadlineGroupingService.swift
//  Cronos
//
//  Created by Assistant on 18/10/25.
//

import Foundation

final class DeadlineGroupingService {

  static func groupDeadlines(
    _ deadlines: [Deadline],
    by grouping: DeadlineGrouping
  ) -> [DeadlineGroup] {
    switch grouping {
    case .all:
      return [DeadlineGroup(title: "All Deadlines", deadlines: deadlines)]
    case .byCategory:
      return groupByCategory(deadlines)
    case .byTimeframe:
      return groupByTimeframe(deadlines)
    }
  }

  private static func groupByCategory(_ deadlines: [Deadline]) -> [DeadlineGroup] {
    let grouped = Dictionary(grouping: deadlines) { deadline in
      deadline.category?.name ?? "Uncategorized"
    }

    return grouped.map { categoryName, categoryDeadlines in
      DeadlineGroup(title: categoryName, deadlines: categoryDeadlines)
    }
    .sorted { $0.title < $1.title }
  }

  private static func groupByTimeframe(_ deadlines: [Deadline]) -> [DeadlineGroup] {
    var timeframeBuckets = TimeframeBuckets()

    let next30DaysDeadlines = deadlines.filter { deadline in
      deadline.date >= timeframeBuckets.now && deadline.date <= timeframeBuckets.thirtyDaysFromNow
    }

    let next6MonthsDeadlines = deadlines.filter { deadline in
      deadline.date > timeframeBuckets.thirtyDaysFromNow
        && deadline.date <= timeframeBuckets.sixMonthsFromNow
    }

    let nextYearDeadlines = deadlines.filter { deadline in
      deadline.date > timeframeBuckets.sixMonthsFromNow
        && deadline.date <= timeframeBuckets.oneYearFromNow
    }

    let moreThanOneYearDeadlines = deadlines.filter { deadline in
      deadline.date > timeframeBuckets.oneYearFromNow
    }

    var groups: [DeadlineGroup] = []

    if !next30DaysDeadlines.isEmpty {
      groups.append(DeadlineGroup(title: "Next 30 days", deadlines: next30DaysDeadlines))
    }

    if !next6MonthsDeadlines.isEmpty {
      groups.append(DeadlineGroup(title: "Next 6 months", deadlines: next6MonthsDeadlines))
    }

    if !nextYearDeadlines.isEmpty {
      groups.append(DeadlineGroup(title: "Next year", deadlines: nextYearDeadlines))
    }

    if !moreThanOneYearDeadlines.isEmpty {
      groups.append(DeadlineGroup(title: "More than 1 year", deadlines: moreThanOneYearDeadlines))
    }

    return groups
  }
}

// MARK: - Helper Types

private struct TimeframeBuckets {
  let now = Date()

  lazy var thirtyDaysFromNow: Date = {
    Calendar.current.date(byAdding: .day, value: 30, to: now) ?? now
  }()

  lazy var sixMonthsFromNow: Date = {
    Calendar.current.date(byAdding: .month, value: 6, to: now) ?? now
  }()

  lazy var oneYearFromNow: Date = {
    Calendar.current.date(byAdding: .year, value: 1, to: now) ?? now
  }()
}
