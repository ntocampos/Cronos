//
//  GroupsView.swift
//  Cronos
//
//  Created by Assistant on 11/04/25.
//

import SwiftData
import SwiftUI

struct GroupsView: View {
  @Environment(DataContainer.self) private var dataContainer
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]

  @State private var selectedGroupingMode: GroupingMode = .byCategory
  @State private var showingAddDeadline = false
  @State private var deadlineToEdit: Deadline?

  private var groupedDeadlines: [DeadlineGroup] {
    DeadlineGroupingService.groupDeadlines(deadlines, by: selectedGroupingMode)
  }

  var body: some View {
    NavigationStack {
      ZStack {
        ScrollView {
          VStack(spacing: 0) {
            // Picker for grouping mode
            Picker("Group by", selection: $selectedGroupingMode) {
              Text("Category").tag(GroupingMode.byCategory)
              Text("Timeframe").tag(GroupingMode.byTimeframe)
            }
            .pickerStyle(.segmented)
            .padding()

            // Grouped list
            if groupedDeadlines.isEmpty {
              ContentUnavailableView(
                "No Deadlines",
                systemImage: "calendar",
                description: Text("Add your first deadline to get started")
              )
            } else {
              LazyVStack(spacing: 24, pinnedViews: []) {
                ForEach(groupedDeadlines) { group in
                  VStack(alignment: .leading, spacing: 8) {
                    // Section header
                    GroupHeaderView(
                      title: group.title,
                      count: group.deadlines.count,
                      color: group.color
                    )
                    .padding(.horizontal, 16)

                    // Deadlines in this group
                    LazyVStack(spacing: 12) {
                      ForEach(group.deadlines) { deadline in
                        DeadlineBarView(
                          deadline: deadline,
                          maxDaysReference: group.maxDaysReference ?? 30
                        )
                        .padding(.horizontal, 16)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                          Button(action: {
                            editDeadline(deadline)
                          }) {
                            Image(systemName: "pencil")
                          }
                          .tint(.blue)

                          Button(
                            role: .destructive,
                            action: {
                              deleteDeadline(deadline)
                            }
                          ) {
                            Image(systemName: "trash")
                          }
                        }
                      }
                    }
                  }
                }
              }
              .padding(.vertical, 6)
            }
          }
        }
        .animation(.default, value: selectedGroupingMode)
      }
      .navigationTitle("Groups")
      .navigationBarTitleDisplayMode(.large)
      .deadlineToolbar()
      .sheet(item: $deadlineToEdit) { deadline in
        DeadlineFormView(deadline: deadline)
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
    }
  }

  private func editDeadline(_ deadline: Deadline) {
    deadlineToEdit = deadline
  }

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      dataContainer.context.delete(deadline)
    }
  }
}

// MARK: - Group Header View

struct GroupHeaderView: View {
  let title: String
  let count: Int
  let color: Color?

  @AppStorage(SettingsKeys.deadlineDensity) private var deadlineDensity: DeadlineDensity = .detailed

  var body: some View {
    HStack(spacing: 8) {
      // Color indicator
      if let color = color {
        Circle()
          .fill(color)
          .frame(width: 12, height: 12)
      }

      // Title and count
      Text(title)
        .font(.headline)
        .fontWeight(.semibold)

      Text("(\(count))")
        .font(.subheadline)
        .foregroundColor(.secondary)

      Spacer()
    }
    .padding(.vertical, 8)
    .textCase(nil)
    .animation(.bouncy, value: deadlineDensity)
  }
}

#Preview("Category Grouping") {
  GroupsView()
    .sampleDataContainer()
}

#Preview("Empty State") {
  GroupsView()
    .emptyDataContainer()
}
