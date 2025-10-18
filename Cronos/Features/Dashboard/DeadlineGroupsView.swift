//
//  DeadlineGroupsView.swift
//  Cronos
//
//  Created by Moisés Neto on 18/10/25.
//

import Foundation
import SwiftData
import SwiftUI

struct DeadlineGroupsView: View {
  // MARK: - Properties

  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]

  @State private var selectedGroup: DeadlineGrouping = .all
  @State private var deadlineToEdit: Deadline?

  // MARK: - Computed Properties

  private var groupedDeadlines: [DeadlineGroup] {
    DeadlineGroupingService.groupDeadlines(deadlines, by: selectedGroup)
  }

  // MARK: - Body

  var body: some View {
    VStack(spacing: 0) {
      groupingFilterView
      deadlinesContentView
    }
    .sheet(item: $deadlineToEdit, content: editDeadlineSheet)
  }

  // MARK: - View Components

  @ViewBuilder
  private var groupingFilterView: some View {
    Picker("Group by", selection: $selectedGroup) {
      ForEach(DeadlineGrouping.allCases, id: \.self) { grouping in
        Text(grouping.displayName).tag(grouping)
      }
    }
    .pickerStyle(.segmented)
    .padding()
  }

  @ViewBuilder
  private var deadlinesContentView: some View {
    List {
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
    .listStyle(.plain)
  }

  private func editDeadlineSheet(for deadline: Deadline) -> some View {
    DeadlineFormView(deadline: deadline)
      .presentationDetents([.large])
      .presentationDragIndicator(.visible)
  }

  // MARK: - Actions

  private func editDeadline(_ deadline: Deadline) {
    deadlineToEdit = deadline
  }

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      modelContext.delete(deadline)
    }
  }
}

// MARK: - Preview

#Preview {
  DeadlineGroupsView()
    .modelContainer(.preview)
}
