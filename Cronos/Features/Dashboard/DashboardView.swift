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

  private var filteredDeadlines: [Deadline] {
    guard let selectedCategory else { return deadlines }
    return deadlines.filter { $0.category.id == selectedCategory.id }
  }

  @ViewBuilder
  private var emptyStateView: some View {
    if filteredDeadlines.isEmpty {
      if selectedCategory == nil {
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
          CategoryFilterRow(
            categories: categories,
            allDeadlinesCount: deadlines.count,
            selectedCategory: $selectedCategory
          )

          if let selectedCategory {
            FilterNoticeView(
              categoryName: selectedCategory.name,
              categoryColor: selectedCategory.color
            )
          }

          LazyVStack(spacing: 12) {
            ForEach(filteredDeadlines) { deadline in
              DeadlineBarView(deadline: deadline)
                .accessibilityHint("Double tap to edit")
                .onTapGesture {
                  coordinator.edit(deadline)
                }
                .contextMenu {
                  deadlineContextMenu(for: deadline)
                }
            }
          }
          .padding(.vertical, 6)
          .padding(.horizontal, 16)
          .animation(.default, value: filteredDeadlines.map(\.id))
        }
      }
      .navigationTitle("Overview")
      .navigationBarTitleDisplayMode(.large)
      .deadlineToolbar()
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
