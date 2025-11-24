//
//  DashboardView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
  @Environment(DataContainer.self) private var dataContainer
  @Environment(DeadlineCoordinator.self) private var coordinator
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]

  @State private var showingAddDeadline = false
  @State private var selectedCategory: Category?

  @AppStorage(SettingsKeys.deadlineDensity) private var deadlineDensity: DeadlineDensity = .detailed

  private var filteredDeadlines: [Deadline] {
    guard let selectedCategory else { return deadlines }
    return deadlines.filter { $0.category.id == selectedCategory.id }
  }

  var body: some View {
    @Bindable var coordinator = coordinator

    NavigationStack {
      ZStack {
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
                  .onTapGesture {
                    coordinator.edit(deadline)
                  }
                  .contextMenu {
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
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
          }
        }
        .animation(.default, value: selectedCategory)
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
        if filteredDeadlines.isEmpty && selectedCategory == nil {
          ContentUnavailableView(
            "No Deadlines",
            systemImage: "calendar",
            description: Text("Add your first deadline to get started")
          )
        } else if filteredDeadlines.isEmpty && selectedCategory != nil {
          ContentUnavailableView(
            "No Items in This Category",
            systemImage: "tray",
            description: Text(
              "Try selecting a different category or add a new deadline"
            )
          )
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var coordinator = DeadlineCoordinator()

  DashboardView()
    .environment(coordinator)
    .sampleDataContainer()
}
