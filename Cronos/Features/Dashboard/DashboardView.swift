//
//  DashboardView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
  @Environment(DeadlineCoordinator.self) private var coordinator
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]

  @State private var selectedCategory: Category?
  @State private var selectedGroupingMode: GroupingMode = .none
  @State private var selectedFilterMode: DeadlineFilterMode = .active

  private var filteredDeadlines: [Deadline] {
    // First filter by completion status
    let statusFiltered = deadlines.filter {
      selectedFilterMode == .active ? !$0.isComplete : $0.isComplete
    }

    // Then filter by category if selected
    guard let selectedCategory else { return statusFiltered }
    return statusFiltered.filter { $0.category.id == selectedCategory.id }
  }

  private var groupedDeadlines: [DeadlineGroup] {
    // Always filter by completion status first
    let statusFiltered = deadlines.filter {
      selectedFilterMode == .active ? !$0.isComplete : $0.isComplete
    }

    // Apply category filter only when not grouping
    let source: [Deadline]
    if selectedGroupingMode == .none, let selectedCategory {
      source = statusFiltered.filter { $0.category.id == selectedCategory.id }
    } else {
      source = statusFiltered
    }

    return DeadlineGroupingService.groupDeadlines(source, by: selectedGroupingMode)
  }

  @ViewBuilder
  private var emptyStateView: some View {
    if filteredDeadlines.isEmpty {
      if selectedFilterMode == .completed {
        ContentUnavailableView(
          "No Completed Deadlines",
          systemImage: "checkmark.circle",
          description: Text("Completed deadlines will appear here")
        )
      } else if selectedCategory == nil {
        ContentUnavailableView(
          "No Deadlines",
          systemImage: "calendar",
          description: Text("Add your first deadline to get started")
        )
      } else {
        ContentUnavailableView(
          "No Items in This Category",
          systemImage: "tray",
          description: Text("Try selecting a different category or add a new deadline")
        )
      }
    }
  }

  var body: some View {
    @Bindable var coordinator = coordinator

    NavigationStack {
      ScrollView {
        VStack(spacing: 0) {
          // Grouping notice (when grouping is active)
          if selectedGroupingMode != .none {
            GroupingNoticeView(groupingMode: selectedGroupingMode) {
              withAnimation {
                selectedGroupingMode = .none
              }
            }
            .padding(.bottom, 8)
          } else {
            // Category filter (only when no grouping)
            CategoryFilterRow(
              categories: categories,
              allDeadlinesCount: deadlines.count,
              selectedCategory: $selectedCategory
            )

            if let selectedCategory {
              FilterNoticeView(
                categoryName: selectedCategory.name,
                categoryColor: selectedCategory.color
              ) {
                withAnimation {
                  self.selectedCategory = nil
                }
              }
            }
          }

          // Unified deadline rendering
          LazyVStack(spacing: 24) {
            ForEach(groupedDeadlines) { group in
              VStack(alignment: .leading, spacing: 8) {
                // Only show header when grouping is active
                if selectedGroupingMode != .none {
                  GroupHeaderView(
                    title: group.title,
                    count: group.deadlines.count,
                    color: group.color
                  )
                  .padding(.horizontal, 16)
                }

                LazyVStack(spacing: 12) {
                  ForEach(group.deadlines) { deadline in
                    DeadlineBarView(
                      deadline: deadline,
                      maxDaysReference: group.maxDaysReference ?? 30
                    )
                    .accessibilityHint("Double tap to edit")
                    .onTapGesture {
                      coordinator.edit(deadline)
                    }
                    .contextMenu {
                      deadlineContextMenu(for: deadline)
                    }
                  }
                }
                .padding(.horizontal, 16)
              }
            }
          }
          .padding(.vertical, 6)
          .animation(.default, value: groupedDeadlines.flatMap { $0.deadlines.map(\.id) })
        }
      }
      .navigationTitle("Overview")
      .navigationBarTitleDisplayMode(.large)
      .deadlineToolbar(
        groupingMode: $selectedGroupingMode,
        filterMode: $selectedFilterMode
      )
      .sheet(item: $coordinator.deadlineToEdit) { deadline in
        DeadlineFormView(deadline: deadline)
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
      .overlay {
        emptyStateView
      }
    }
  }

  @ViewBuilder
  private func deadlineContextMenu(for deadline: Deadline) -> some View {
    Button("Complete", systemImage: "checkmark") {
      coordinator.complete(deadline)
    }
    Button("Edit", systemImage: "square.and.pencil") {
      coordinator.edit(deadline)
    }
    Divider()
    Button("Delete", systemImage: "trash", role: .destructive) {
      coordinator.delete(deadline, context: modelContext)
    }
  }
}

#Preview {
  @Previewable @State var coordinator = DeadlineCoordinator()

  DashboardView()
    .environment(coordinator)
    .sampleDataContainer()
}
