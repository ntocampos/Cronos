//
//  DeadlineGroups.swift
//  Cronos
//
//  Created by Moisés Neto on 18/10/25.
//

import Foundation
import SwiftData
import SwiftUI

enum DeadlineGrouping {
  case all
  case byCategory
  case byTimeframe
}

struct DeadlineGroup: Identifiable {
  let id = UUID()
  let title: String
  let deadlines: [Deadline]
}

struct DeadlineGroupsView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]

  @State private var selectedGroup: DeadlineGrouping = .all
  @State private var deadlineToEdit: Deadline? = nil

  var body: some View {
    let groupedDeadlines: [DeadlineGroup] = computeGroupedData()

    VStack {
      filter

      switch selectedGroup {
      case .all:
        DeadlineListView(
          deadlines: deadlines,
          onEdit: editDeadline,
          onDelete: deleteDeadline
        )
      case .byCategory, .byTimeframe:
        ForEach(groupedDeadlines) { group in
          DeadlineListView(
            deadlines: group.deadlines,
            onEdit: editDeadline,
            onDelete: deleteDeadline,
            sectionTitle: group.title
          )
        }
      }
    }
    .sheet(item: $deadlineToEdit) { deadline in
      DeadlineFormView(deadline: deadline)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
  }

  private var filter: some View {
    Picker("Group by", selection: $selectedGroup) {
      Text("All").tag(DeadlineGrouping.all)
      Text("By Category").tag(DeadlineGrouping.byCategory)
      Text("By Timeframe").tag(DeadlineGrouping.byTimeframe)
    }
    .pickerStyle(.segmented)
    .padding()
  }

  private func editDeadline(_ deadline: Deadline) {
    self.deadlineToEdit = deadline
  }

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      modelContext.delete(deadline)
    }
  }

  private func computeGroupedData() -> [DeadlineGroup] {
    switch selectedGroup {
    case .byCategory:
      return groupByCategory()
    case .byTimeframe:
      return groupByTimeframe()
    default:
      return [DeadlineGroup(title: "All Deadlines", deadlines: deadlines)]
    }
  }

  private func groupByCategory() -> [DeadlineGroup] {
    let grouped = Dictionary(grouping: deadlines) { deadline in
      deadline.category?.name ?? "Uncategorized"
    }

    return grouped.map { categoryName, categoryDeadlines in
      DeadlineGroup(title: categoryName, deadlines: categoryDeadlines)
    }
    .sorted { $0.title < $1.title }

  }

  private func groupByTimeframe() -> [DeadlineGroup] {
    let now = Date()
    let thirtyDaysFromNow = Calendar.current.date(byAdding: .day, value: 30, to: now) ?? now
    let sixMonthsFromNow = Calendar.current.date(byAdding: .month, value: 6, to: now) ?? now
    let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: now) ?? now

    // Next 30 days: from now to 30 days
    let next30DaysDeadlines = deadlines.filter { deadline in
      deadline.date >= now && deadline.date <= thirtyDaysFromNow
    }

    // Next 6 months: from 30 days to 6 months
    let next6MonthsDeadlines = deadlines.filter { deadline in
      deadline.date > thirtyDaysFromNow && deadline.date <= sixMonthsFromNow
    }

    // Next year: from 6 months to 1 year
    let nextYearDeadlines = deadlines.filter { deadline in
      deadline.date > sixMonthsFromNow && deadline.date <= oneYearFromNow
    }

    // More than 1 year: beyond 1 year from now
    let moreThanOneYearDeadlines = deadlines.filter { deadline in
      deadline.date > oneYearFromNow
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

#Preview {
  DeadlineGroupsView()
    .modelContainer(.preview)
}
