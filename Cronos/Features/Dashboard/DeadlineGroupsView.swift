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
      case .byCategory:
        ForEach(groupedDeadlines) { group in
          DeadlineListView(
            deadlines: group.deadlines,
            onEdit: editDeadline,
            onDelete: deleteDeadline,
            sectionTitle: group.title
          )
        }
      case .byTimeframe:
        Text("Not implemented yet")
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
      return []
    case .all:
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
}

#Preview {
  DeadlineGroupsView()
    .modelContainer(.preview)
}
