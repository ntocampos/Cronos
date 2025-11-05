//
//  GroupsView.swift
//  Cronos
//
//  Created by Assistant on 11/04/25.
//

import SwiftData
import SwiftUI

struct GroupsView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]

  @State private var selectedGroupingMode: GroupingMode = .byCategory
  @State private var showingAddDeadline = false
  @State private var deadlineToEdit: Deadline?

  private var groupedDeadlines: [DeadlineGroup] {
    DeadlineGroupingService.groupDeadlines(deadlines, by: selectedGroupingMode)
  }

  var body: some View {
    NavigationStack {
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
          List {
            ForEach(groupedDeadlines) { group in
              Section {
                ForEach(group.deadlines) { deadline in
                  DeadlineBarView(
                    deadline: deadline,
                    maxDaysReference: group.maxDaysReference ?? 30
                  )
                  .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                  .listRowBackground(Color.clear)
                  .listRowSeparator(.hidden)
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
              } header: {
                GroupHeaderView(
                  title: group.title,
                  count: group.deadlines.count,
                  color: group.color
                )
              }
            }
          }
          .listStyle(.plain)
        }
      }
      .navigationTitle("Groups")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { showingAddDeadline = true }) {
            Label("Add Deadline", systemImage: "plus")
          }
        }
      }
      .sheet(isPresented: $showingAddDeadline) {
        DeadlineFormView()
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
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
      modelContext.delete(deadline)
    }
  }
}

// MARK: - Group Header View

struct GroupHeaderView: View {
  let title: String
  let count: Int
  let color: Color?

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
  }
}

#Preview("Category Grouping") {
  GroupsView()
    .modelContainer(.preview)
}

#Preview("Empty State") {
  GroupsView()
    .modelContainer(.emptyPreview)
}
